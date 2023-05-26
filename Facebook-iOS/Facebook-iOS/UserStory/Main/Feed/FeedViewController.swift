//
//  FeedViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

final class FeedViewController: BaseViewController {
    
    private let tableView = UITableView()
    var post: FeedData
    
    convenience init(post: FeedData) {
        self.post = post
    }
    
    weak var coordinator: (any FeedCoordinatorProtocol)?
    private let feedViewModel: FeedViewModelProtocol = FeedViewModel()
    private let feedView = FeedView(post: FeedData)
    
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
