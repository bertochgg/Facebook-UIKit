//
//  FeedViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import Foundation

protocol FeedViewModelDelegate: AnyObject {
    func didFetchFeedData()
}

protocol FeedViewModelProtocol: AnyObject {
    var delegate: FeedViewModelDelegate? { get set }
    func fetchFeedData()
}

final class FeedViewModel: FeedViewModelProtocol {
    
    weak var delegate: FeedViewModelDelegate?
    private let feedNetworkService: FeedNetworkServiceProtocol = FeedNetworkService()
    
    func fetchFeedData() {
        feedNetworkService.fetchFeedData { result in
            switch result {
            case .success(let feedData):
                for idx in 0..<3 {
                    print(feedData.data[idx])
                }
            case .failure(let error):
                print("Error fetching user profile data: \(NetworkServiceErrors.decodingFailed)")
                print(error.localizedDescription)
            }
        }
    }
}
