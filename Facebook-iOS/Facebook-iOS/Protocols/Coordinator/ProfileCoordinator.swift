//
//  ProfileCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import UIKit

protocol ProfileCoordinatorProtocol: Coordinator {
    func showProfileViewController()
}

final class ProfileCoordinator: ProfileCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
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
        profileViewController.profileFinishDelegate = self
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

extension ProfileCoordinator: ProfileCoordinatorFinishDelegate {
    func didFinishProfileCoordinator() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
