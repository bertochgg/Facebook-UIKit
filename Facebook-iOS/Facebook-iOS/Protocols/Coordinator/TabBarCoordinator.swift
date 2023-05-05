//
//  TabBarCoordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarOptions)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarOptions?
}

class TabBarCoordinator: NSObject, Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
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
        tabBarController.selectedIndex = TabBarOptions.feed.pageOrderNumber()
        // Styling
        tabBarController.tabBar.isTranslucent = false
        // tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.backgroundColor = .white
        
        // In this step, we attach tabBarController to navigation controller associated with this coordanator
        // navigationController.viewControllers = [tabBarController]
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        
        navigationController.present(tabBarController, animated: true)
        
    }
    
    private func getTabController(_ page: TabBarOptions) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: true)
        
        switch page {
        case .feed:
            // If needed: Each tab bar flow can have it's own Coordinator.
            navController.tabBarItem = UITabBarItem(title: page.pageTitleValue(),
                                                    image: ImagesNames.feed,
                                                         tag: page.pageOrderNumber())
            let feedVC = FeedViewController()
            navController.pushViewController(feedVC, animated: true)
        case .profile:
            navController.tabBarItem = UITabBarItem(title: page.pageTitleValue(),
                                                    image: ImagesNames.profile,
                                                         tag: page.pageOrderNumber())
            let profileVC = ProfileViewController()
            navController.pushViewController(profileVC, animated: true)
        
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
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
