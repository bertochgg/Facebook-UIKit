//
//  TabBarOptions.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import Foundation

enum TabBarOptions {
    case feed
    case profile

    init?(index: Int) {
        switch index {
        case 0:
            self = .feed
        case 1:
            self = .profile
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .feed:
            return "Feed"
        case .profile:
            return "Profile"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .feed:
            return 0
        case .profile:
            return 1
        }
    }

    // Add tab icon value
    
    // Add tab icon selected / deselected color
    
    // etc
}
