//
//  ProfileCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import UIKit

protocol ProfileCoordinatorProtocol: Coordinator {
    func showProfileViewController()
    func showCreatePostViewController()
}

final class ProfileCoordinator: ProfileCoordinatorProtocol, CreatePostCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController?
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType { .myProfile }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showProfileViewController()
        guard let navController = navigationController else { return }
        let createPostCoordinator = CreatePostCoordinator(navigationController: navController)
        self.childCoordinators.append(createPostCoordinator)
    }

    deinit {
        print("Bye: from ProfileCoordinator - ProfileViewController")
    }
    
    func showProfileViewController() {
        let profileViewController = ProfileViewController()
        profileViewController.coordinator = self
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func showCreatePostViewController() {
        let createPostViewController = CreatePostViewController()
        createPostViewController.coordinator = self
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(createPostViewController, animated: true)
    }
}

extension ProfileCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: any Coordinator) {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
