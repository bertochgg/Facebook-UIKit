//
//  FeedServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import Foundation

protocol FeedNetworkServiceProtocol {
    func fetchInitialFeedData(completion: @escaping (Result<FeedData, NetworkServiceErrors>) -> Void)
    func fetchNewFeedData(currentPageURL: String, completion: @escaping (Result<FeedData, NetworkServiceErrors>) -> Void)
}
