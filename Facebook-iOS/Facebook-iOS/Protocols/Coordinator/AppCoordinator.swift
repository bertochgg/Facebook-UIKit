//
//  AppCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 25/04/23.
//

import Foundation
import UIKit

// Define what type of flows can be started from this Coordinator
protocol AppCoordinatorProtocol: Coordinator, AnyObject {
    func showSignIn()
    func showMainScreen()
}

// App coordinator is the only one coordinator which will exist during app's life cycle
class AppCoordinator: AppCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController?
    
    var childCoordinators = [any Coordinator]()
    
    var type: CoordinatorType { .application }
    
    private let keychainService: KeychainServiceProtocol = KeychainService(serviceName: KeychainKeys.keychainServiceName)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        keychainService.loadData(forKey: KeychainKeys.userAccessTokenKey, completion: { result in
            switch result {
            case .success:
                // If access token is present, then show main scree. Question: how do I read access token, string, data, do I need to decode?
                print("sign in successful, i go to main screen")
                self.showMainScreen()
                
            case .failure:
                // If access token is NOT present, then go again to SignIn until it is successful
                self.showSignIn()
            }
        })
        
    }
    
    func showSignIn() {
        guard let navigationController = navigationController else {
            return
        }
        let signInCoordinator = SignInCoordinator(navigationController: navigationController )
        signInCoordinator.finishDelegate = self
        signInCoordinator.start()
        childCoordinators.append(signInCoordinator)
        
    }
    
    func showMainScreen() {
        guard let navigationController = navigationController else {
            return
        }
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: any Coordinator) {
        guard let navigationController = navigationController else {
            return
        }
        
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .tabBar:
            navigationController.viewControllers.removeAll()
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            navigationController.view.layer.add(transition, forKey: nil)
            
            showSignIn()
        case .signIn:
            navigationController.viewControllers.removeAll()
            
            showMainScreen()
        default:
            break
        }
    }
}
