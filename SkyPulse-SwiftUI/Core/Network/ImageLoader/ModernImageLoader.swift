//
//  ModernImageLoader.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 06/11/26.
//

import Foundation
import UIKit

/// Thread-safe Actor for image downloading, memory caching, and task deduplication
actor ModernImageLoader {
    static let shared = ModernImageLoader()

    private let memoryCache = NSCache<NSURL, UIImage>()
    private var activeTasks: [URL: Task<UIImage, Error>] = [:]

    private init() {
        memoryCache.countLimit = 150
        memoryCache.totalCostLimit = 1024 * 1024 * 60 // 60 MB
    }

    /// Fetches an image from memory cache, in-flight task, or network
    func fetch(_ url: URL) async throws -> UIImage {
        let nsURL = url as NSURL

        // 1. RAM Cache lookup
        if let cached = memoryCache.object(forKey: nsURL) {
            return cached
        }

        // 2. In-flight request deduplication
        if let ongoing = activeTasks[url] {
            return try await ongoing.value
        }

        // 3. New download task
        let task = Task<UIImage, Error> {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let image = UIImage(data: data) else {
                throw URLError(.badServerResponse)
            }

            self.memoryCache.setObject(image, forKey: nsURL, cost: data.count)
            return image
        }

        activeTasks[url] = task
        defer { activeTasks[url] = nil }

        return try await task.value
    }
}
