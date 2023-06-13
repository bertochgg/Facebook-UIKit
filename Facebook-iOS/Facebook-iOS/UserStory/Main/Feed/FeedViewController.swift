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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        navigationItem.titleView = UIImageView(image: ImagesNames.fbBarTitle)
        feedViewModel.delegate = self
        feedView.delegate = self
        feedViewModel.fetchFeedData()
        self.showProgress("Loading...")
    }
    
}

extension FeedViewController: FeedViewModelDelegate {
    func didFetchFeedData(feedData: [FeedTableViewCellViewModel]) {
        feedView.setHasMoreDataToLoad(true)
        feedView.applySnapshot(with: feedData)
        feedView.resetLoadingState()
        self.hideProgress(completion: nil)
    }
    
    func didFailFetchingFeedData(with error: NetworkServiceErrors) {
        let title = "Error"
        let message = error.localizedDescription
        self.hideProgress(completion: nil)
        showErrorAlert(title: title, message: message)
        feedView.resetLoadingState()
    }
    
    func didReachEndOfData() {
        print("chi toy :3")
        feedView.setHasMoreDataToLoad(false)
        feedView.resetLoadingState()
        feedViewModel.resetLoadStateWhenHasNoMoreData()
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension FeedViewController: FeedViewDelegate {
    func didReachEndOfFeed() {
        feedViewModel.fetchNewFeedData()
        
    }
    
    func didRefreshTriggered() {
        feedViewModel.fetchFeedData()
    }
}
