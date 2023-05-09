//
//  SignInCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

protocol SignInCoordinatorProtocol: Coordinator {
    func showSignInViewController()
}

class SignInCoordinator: SignInCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController?
    var childCoordinators: [any Coordinator] = []
    var type: CoordinatorType { .signIn }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSignInViewController()
    }
    
    deinit {
        print("Bye: from SignInCoordinator - SignInViewController")
    }
    
    func showSignInViewController() {
        let signInViewController = SignInViewController()
        signInViewController.coordinator = self
        navigationController?.pushViewController(signInViewController, animated: false)
    }
    
}
