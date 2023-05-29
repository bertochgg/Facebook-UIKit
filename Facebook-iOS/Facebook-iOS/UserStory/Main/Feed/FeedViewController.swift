//
//  FeedViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

final class FeedViewController: BaseViewController {
    
    weak var coordinator: (any FeedCoordinatorProtocol)?
    private let feedViewModel: FeedViewModelProtocol = FeedViewModel()
    private let feedView = FeedView()
    
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        navigationItem.titleView = UIImageView(image: ImagesNames.fbBarTitle)
        feedViewModel.delegate = self
        feedViewModel.fetchFeedData()
    }
    
}

extension FeedViewController: FeedViewModelDelegate {
    
    func didFetchFeedData() {
        
    }
    
}
