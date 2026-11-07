//
//  AuthManager.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 07/11/26.
//

import Foundation
import SwiftUI

@Observable
final class AuthManager {
    
    static let shared = AuthManager()
    
    var currentUser: User?
    
    var isLoggedIn: Bool {
        (currentUser != nil)
    }
    
    private let userKey = "cached_skypulse_user"
    private let tokenKey = "auth_access_token"
    
    private init() {}
    
    private func restoreSession() {
        
        guard let tokenData = KeychainManager.shared.getLoginData(key: tokenKey),
              let token = String(data: tokenData, encoding: .utf8),
              !token.isEmpty else {
            self.currentUser = nil
            return
        }
        
        if let userData = UserDefaults.standard.data(forKey: userKey),
           let cachedUser = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = cachedUser
        }
    }
    
    @MainActor
    func login(user: User, token: String){
        
        // 1. To save in token keychain
        if let tokenData = token.data(using: .utf8) {
            KeychainManager.shared.saveLoginData(key: tokenKey, data: tokenData)
        }
        
        // 2.
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
        
        // 3. state update
        self.currentUser = user
    }
    
    @MainActor
    func logout() {
        KeychainManager.shared.deleteLoginData(key: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
        self.currentUser = nil
    }
}


struct User: Codable, Equatable {
    let userId: String
    let name: String
    let email:String
    let phone: String
    let avatarURL: String
}
