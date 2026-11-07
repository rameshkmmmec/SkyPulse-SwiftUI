//
//  KeychainManager.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 07/11/26.
//

import Foundation
import Security

final class KeychainManager {
    
    static let shared = KeychainManager()
    private let service = "com.skypulse.app.auth"
    
    private init() {}
    
    
    func saveLoginData(key: String, data: Data) {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as [CFString: Any]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getLoginData(key: String) -> Data? {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [CFString: Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        return status == errSecSuccess ? (dataTypeRef as? Data) : nil
        
    }
    
    func deleteLoginData(key: String) {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ] as [CFString: Any]
        
        SecItemDelete(query as CFDictionary)
        
    }
    
}
