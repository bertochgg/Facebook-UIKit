//
//  KeyChainServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import Foundation

protocol KeychainServiceProtocol {
    
    func save(data: Data, forKey key: String, completion: @escaping (KeychainResult) -> Void)
    func loadData(forKey key: String, completion: @escaping (KeychainLoadResult) -> Void)
    func update(_ data: Data, forKey key: String, completion: @escaping (KeychainResult) -> Void)
    func deleteCache(forKey key: String, completion: @escaping (KeychainResult) -> Void)
    
}
