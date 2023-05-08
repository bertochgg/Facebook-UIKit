//
//  KeyChainService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 05/05/23.
//

import Foundation

// Result from operations that does not returns any value on success case
typealias KeychainResult = Swift.Result<Void, Error>

// Result from operations that returns Data value on success case
typealias KeychainLoadResult = Swift.Result<Data, Error>

enum KeychainKeys {
    static let userAccessTokenKey = "accessToken"
    static let tokenExpirationDateKey = "tokenExpirationDate"
    static let keychainServiceName = "com.bertochgg.UltimateSocialApp"
}

final class KeychainService: KeychainServiceProtocol {
    
    private var serviceName: String
    
    init(serviceName: String) {
        self.serviceName = serviceName
    }
    
    // Save a Data value for a given key
    // - Parameters:
    //   - data: The Data to be saved
    //   - key: The key used to identify the data on Keychain after being saved
    //   - completion: The block to execute after the data save operation finishes. This block has no return value on success case and takes no parameters.
    func save(data: Data, forKey key: String, completion: @escaping (KeychainResult) -> Void) {
        var query = createBaseQueryDicionary(forKey: key)
        query[kSecValueData as String] = data
        
        var result: CFTypeRef?
        let status: OSStatus = SecItemAdd(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            completion(.success(()))
        } else if status == errSecDuplicateItem {
            completion(.failure(KeychainError.duplicatedItem))
        } else if let error = result?.error, let finalError = error {
            completion(.failure(finalError))
        } else {
            completion(.failure(KeychainError.unexpectedError(.max)))
        }
    }
    
    // Generates a base dictionary with the default values for the save, update and delete operations for a given key
    // - Parameter key: The key used to identifiy the data on Keychain
    // - Returns: The base dictionary with the default values
    private func createBaseQueryDicionary(forKey key: String) -> [String: Any?] {
        let encodedKey = key.data(using: .utf8)
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.serviceName,
            kSecAttrGeneric as String: encodedKey,
            kSecAttrAccount as String: encodedKey,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
    }
    
    // Load Data for a given key
    // - Parameters:
    //   - key: The key used to locate the saved data on Keychain
    //   - completion: The block to execute after the data load operation finishes. This block returns a Data value on success case and takes no parameters.
    func loadData(forKey key: String, completion: @escaping (KeychainLoadResult) -> Void) {
        var query = self.createBaseQueryDicionary(forKey: key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var result: CFTypeRef?
        _ = SecItemCopyMatching(query as CFDictionary, &result)
        
        if let data = result as? Data {
            completion(.success(data))
        } else if let error = result?.error, let finalError = error {
            completion(.failure(finalError))
        } else {
            completion(.failure(KeychainError.unexpectedError(.max)))
        }
    }
    
    // Update a  Data value for a given key
    // - Parameters:
    //   - data: The Data to be updated
    //   - key: The key used to identify the data on Keychain after being updated
    //   - completion: The block to execute after the data update operation finishes. This block has no return value on success case and takes no parameters.
    func update(_ data: Data, forKey key: String, completion: @escaping (KeychainResult) -> Void) {
        let query = self.createBaseQueryDicionary(forKey: key) as CFDictionary
        let updateDictionary = [kSecValueData as String: data] as CFDictionary
        
        let status: OSStatus = SecItemUpdate(query, updateDictionary)
        
        completion(status == errSecSuccess ? .success(()) : .failure(KeychainError.unexpectedError(.max)))
    }
    
    // Delete a cached value for a given key
    // - Parameters:
    //   - key: The key used to identify the saved data on Keychain
    //   - completion: The block to execute after the data delete operation finishes. This block has no return value on success case and takes no parameters.
    func deleteCache(forKey key: String, completion: @escaping (KeychainResult) -> Void) {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.serviceName
        ] as CFDictionary
        
        let status: OSStatus = SecItemDelete(query)
        
        completion(status == errSecSuccess ? .success(()) : .failure(KeychainError.unexpectedError(.max)))
    }
    
}
