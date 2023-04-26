//
//  AppCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 25/04/23.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signInViewController = SignInViewController()
        signInViewController.coordinator = self
        signInViewController.viewModel = SignInViewModel()
        navigationController?.pushViewController(signInViewController, animated: true)
    }
}
