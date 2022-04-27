//
//  UIFont+Extension.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/27/22.
//

import UIKit

private enum FontName: String, CaseIterable {
    
    case ralewayLight = "Raleway-Light"
    case ralewayRegular = "Raleway-Regular"
    case ralewayMedium = "Raleway-Medium"
    case ralewaySemiBold = "Raleway-SemiBold"
    case ralewayBold = "Raleway-Bold"
}

extension UIFont {
    
    // MARK: - Raleway Bold
    static var ralewayBold28: UIFont {
        guard let font = UIFont(name: FontName.ralewayBold.rawValue, size: 28.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 28.0, weight: .bold)
        }
        return font
    }
    
    // MARK: - Raleway Medium
    static var ralewayMedium20: UIFont {
        guard let font = UIFont(name: FontName.ralewayMedium.rawValue, size: 20.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 20.0, weight: .medium)
        }
        return font
    }
    
    static var ralewayMedium18: UIFont {
        guard let font = UIFont(name: FontName.ralewayMedium.rawValue, size: 18.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 18.0, weight: .medium)
        }
        return font
    }
}
