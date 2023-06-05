//
//  FeedServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import Foundation

protocol FeedNetworkServiceProtocol {
    func fetchFeedData(graphPath: String, parameters: [String: Any], completion: @escaping (Result<FeedData, NetworkServiceErrors>) -> Void)
}
