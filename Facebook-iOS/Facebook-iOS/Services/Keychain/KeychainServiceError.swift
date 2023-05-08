//
//  KeychainServiceError.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import Foundation

enum KeychainError: Error {
    // Attempted read for an item that does not exist.
    case itemNotFound
    
    // Attempted save to override an existing item.
    // Use update instead of save to update existing items
    case duplicatedItem
    
    // A read of an item in any format other than Data
    case invalidItemFormat
    
    // Any operation result status than errSecSuccess
    case unexpectedError(OSStatus)
}
