//
//  SceneDelegate.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/15/22.
//

import UIKit

final class SceneDelegate: UIResponder {

    // https://stackoverflow.com/questions/56588843/uiapplication-shared-delegate-equivalent-for-scenedelegate-xcode11
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    static var shared: SceneDelegate {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate else {
                    preconditionFailure("Unable to get AppDelegate")
                }
        return sceneDelegate
    }
}

// MARK: - UIWindowSceneDelegate
extension SceneDelegate: UIWindowSceneDelegate {
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationViewController = UINavigationController()
//        guard let coordinator = appCoordinator else { return }
        appCoordinator = AppCoordinator(navigationController: navigationViewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        self.window = window
        
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
