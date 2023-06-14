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

final class ProfileCoordinator: ProfileCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController?
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType { .myProfile }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showProfileViewController()
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
        guard let navigationController = navigationController else { return }
        let createPostCoordinator = CreatePostCoordinator(navigationController: navigationController)
        createPostCoordinator.finishDelegate = self
        self.childCoordinators.append(createPostCoordinator)
        createPostCoordinator.start()
    }
}

extension ProfileCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: any Coordinator) {
        guard let navigationController = navigationController else {
            return
        }
        
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .createPost:
            navigationController.popViewController(animated: true)
            navigationController.setNavigationBarHidden(true, animated: true)
        default:
            break
        }
    }
}
