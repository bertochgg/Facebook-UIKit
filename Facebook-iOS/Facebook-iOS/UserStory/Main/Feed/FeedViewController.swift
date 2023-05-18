//
//  FeedViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

final class FeedViewController: UIViewController {
    
    weak var coordinator: (any FeedCoordinatorProtocol)?
    private let feedViewModel: FeedViewModelProtocol = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        feedViewModel.delegate = self
        feedViewModel.fetchFeedData()
    }
    
}

extension FeedViewController: FeedViewModelDelegate {
    
    func didFetchFeedData() {
        
    }
    
}
