//
//  FeedServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import Foundation

protocol FeedNetworkServiceProtocol {
    func fetchFeedData(completion: @escaping (Result<FeedData, NetworkServiceErrors>) -> Void)
}
