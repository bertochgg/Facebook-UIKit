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

// Delegate protocol helping parent Coordinator know when its child is ready to be finished.
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: any Coordinator)
}

protocol Coordinator: Hashable, Equatable, AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    // Array to keep tracking of all child coordinators. Most of the time this array will contain only one child coordinator
    var childCoordinators: [any Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    // Defined flow type.
    var type: CoordinatorType { get }
    // A place to put logic to start the flow.
    func start()
    // A place to put logic to finish the flow, to clean all children coordinators, and to notify the parent that this coordinator is ready to be deallocated
    func finish()
}

extension Coordinator {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self) // Parameter may change
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs == rhs
    }
    
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
