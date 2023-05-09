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
    
    func fetchFeedData() {
        
    }
}
