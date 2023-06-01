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
        self.showProgress("Loading...")
    }
    
}

extension FeedViewController: FeedViewModelDelegate {
    func didFetchFeedData(feedData: [FeedTableViewCellViewModel]) {
        feedView.applySnapshot(with: feedData)
        self.hideProgress(completion: nil)
    }
    
    func didFailFetchingFeedData(with error: NetworkServiceErrors) {
        let title = "Error"
        let message = error.localizedDescription
        showErrorAlert(title: title, message: message)
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true)
            self.hideProgress(completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
