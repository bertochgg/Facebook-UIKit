//
//  TabBarCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator, AnyObject {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarOptions)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarOptions?
    
    func showFeedScreen()
    func showProfile()
}

class TabBarCoordinator: NSObject, Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController?
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tabBar }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    func start() {
        // Design which pages gonna be in tab bar
        let pages: [TabBarOptions] = [.feed, .profile].sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        guard let navigationController = navigationController else {
            return
        }
        
        // Set delegate for UITabBarController
        tabBarController.delegate = self
        // Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        // Let set index
        tabBarController.selectedIndex = TabBarOptions.profile.pageOrderNumber()
        // Styling
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .white
        
        // In this step, we attach tabBarController to navigation controller associated with this coordanator
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        navigationController.view.layer.add(transition, forKey: nil)
        navigationController.pushViewController(tabBarController, animated: false)
        
    }
    
    private func getTabController(_ page: TabBarOptions) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: true)
        
        switch page {
        case .feed:
            // If needed: Each tab bar flow can have it's own Coordinator.
            navController.tabBarItem = UITabBarItem(title: page.pageTitleValue(),
                                                    image: ImagesNames.feed,
                                                    tag: page.pageOrderNumber())
            let feedCoordinator = FeedCoordinator(navigationController: navController)
            feedCoordinator.start()
        case .profile:
            navController.tabBarItem = UITabBarItem(title: page.pageTitleValue(),
                                                    image: ImagesNames.profile,
                                                    tag: page.pageOrderNumber())
            let profileCoordinator = ProfileCoordinator(navigationController: navController)
            profileCoordinator.start()
            
        }
        
        return navController
    }
    
    func currentPage() -> TabBarOptions? {
        TabBarOptions(index: tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarOptions) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarOptions(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func showFeedScreen() {
        guard let navigationController = navigationController else {
            return
        }
        let feedCoordinator = FeedCoordinator(navigationController: navigationController)
        feedCoordinator.finishDelegate = self
        feedCoordinator.start()
        childCoordinators.append(feedCoordinator)
    }
    
    func showProfileScreen() {
        guard let navigationController = navigationController else {
            return
        }
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.finishDelegate = self
        profileCoordinator.start()
        childCoordinators.append(profileCoordinator)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: any Coordinator) {
        self.childCoordinators.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}
