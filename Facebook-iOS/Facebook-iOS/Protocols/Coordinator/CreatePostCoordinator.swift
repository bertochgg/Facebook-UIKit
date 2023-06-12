//
//  CreatePostCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//

import UIKit

protocol CreatePostCoordinatorProtocol: Coordinator {
    func showCreatePostViewController()
}

final class CreatePostCoordinator: CreatePostCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController?
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType { .createPost }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showCreatePostViewController()
    }
    
    deinit {
        print("Bye: from CreatePostCoordinator - CreatePostViewController")
    }
    
    func showCreatePostViewController() {
        let createPostViewController = CreatePostViewController()
        createPostViewController.coordinator = self
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(createPostViewController, animated: true)
    }
}

extension CreatePostCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: any Coordinator) {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
