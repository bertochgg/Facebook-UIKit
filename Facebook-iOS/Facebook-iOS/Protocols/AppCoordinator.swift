//
//  AppCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 25/04/23.
//

import Foundation
import UIKit

class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    private var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if self.isLoggedIn {
            showMainScreen()
        } else {
            showSignInScreen()
        }
    }
    
    func didChangeNavigation() {
        isLoggedIn = true
    }
    
    func showSignInScreen() {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        signInViewModel.delegate = signInViewController
        signInViewController.coordinator = self
        navigationController?.pushViewController(signInViewController, animated: true)
    }
    
    func showMainScreen() {
        print("You are in main screen")
    }

}
