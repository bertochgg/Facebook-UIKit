//
//  FeedCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import UIKit

protocol FeedCoordinatorProtocol: Coordinator {
    func showFeedViewController()
}

final class FeedCoordinator: FeedCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController?
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType { .feed }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFeedViewController()
    }
    
    deinit {
        print("Bye: from FeedCoordinator - FeedViewController")
    }
    
    func showFeedViewController() {
        let feedViewController = FeedViewController()
        feedViewController.coordinator = self
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.pushViewController(feedViewController, animated: true)
    }
}
