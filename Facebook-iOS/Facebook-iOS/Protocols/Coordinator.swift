//
//  Coordinator.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 23/04/23.
//

import Foundation
import UIKit

enum CoordinatorType {
    case application
    case signIn
    case tabBar
    case feed
    case myProfile
}

protocol Coordinator: Hashable {
    var parentCoordinator: (any Coordinator)? { get set }
    var children: [any Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    func start()
    
}

extension Coordinator {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self) // Parameter may change
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs == rhs
    }
}

protocol Coordinating {
    var coordinator: (any Coordinator)? { get set }
}

class AppCoordinator: Coordinator {
    var parentCoordinator: (any Coordinator)?
    var children: [any Coordinator] = []
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("app coor start")
    }
    
}
