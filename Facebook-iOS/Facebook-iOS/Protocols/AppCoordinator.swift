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
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        // signInViewModel.delegate = signInViewController
        signInViewController.coordinator = self
        navigationController?.pushViewController(signInViewController, animated: true)
    }

}
