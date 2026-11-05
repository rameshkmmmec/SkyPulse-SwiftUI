//
//  CachedAsyncImage.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 06/11/26.
//

import Foundation
import SwiftUI

// MARK: - Remote Image Phase
enum RemoteImagePhase {
    case empty
    case loading
    case success(Image)
    case failure(Error)
}

// MARK: - Reusable Custom View Builder
struct CachedAsyncImage<Content: View>: View {
    private let url: URL?
    private let content: (RemoteImagePhase) -> Content

    @State private var phase: RemoteImagePhase = .empty

    init(
        url: URL?,
        @ViewBuilder content: @escaping (RemoteImagePhase) -> Content
    ) {
        self.url = url
        self.content = content
    }

    var body: some View {
        content(phase)
            .task(id: url) {
                await loadImage()
            }
    }

    private func loadImage() async {
        guard let url = url else {
            phase = .empty
            return
        }

        phase = .loading

        do {
            let uiImage = try await ModernImageLoader.shared.fetch(url)
            guard !Task.isCancelled else { return }
            phase = .success(Image(uiImage: uiImage))
        } catch {
            guard !Task.isCancelled else { return }
            phase = .failure(error)
        }
    }
}

// MARK: - Convenience Initializer (iOS 15+ Compatible)
extension CachedAsyncImage where Content == AnyView {
    init(
        url: URL?,
        contentMode: ContentMode = .fill,
        cornerRadius: CGFloat = 0
    ) {
        self.init(url: url) { phase in
            AnyView(
                Group {
                    switch phase {
                    case .empty, .loading:
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color(white: 0.15))
                            .overlay(
                                ProgressView()
                            )

                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)

                    case .failure:
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color(white: 0.15))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                }
            )
        }
    }
}




//struct RemoteImageView: View {
//    let url: URL?
//    var contentMode: ContentMode = .fill
//    var failureIcon: String = "exclamationmark.triangle"
//
//    var body: some View {
//        CachedAsyncImage(url: url) { phase in
//            switch phase {
//            case .empty, .loading:
//                ZStack {
//                    Color.gray.opacity(0.2)
//                    ProgressView()
//                }
//
//            case .success(let image):
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: contentMode)
//
//            case .failure:
//                ZStack {
//                    Color.gray.opacity(0.3)
//                    Image(systemName: failureIcon)
//                        .foregroundColor(.red)
//                }
//            }
//        }
//        .clipped()
//    }
//}

struct RemoteImageView: View {
    let url: URL?
    var contentMode: ContentMode = .fill

    var body: some View {
        CachedAsyncImage(url: url) { phase in
            switch phase {
            case .empty, .loading:
                Rectangle()
                    .fill(Color(white: 0.15))
                    .overlay(ProgressView())

            case .success(let image):
                GeometryReader { proxy in
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped() // <-- Yeh image ko apne exact frame ke andar lock kar dega
                }

            case .failure:
                Rectangle()
                    .fill(Color(white: 0.15))
                    .overlay(Image(systemName: "photo").foregroundColor(.gray))
            }
        }
    }
}
