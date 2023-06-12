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
    
    case robotoMedium = "Roboto-Medium"
    case robotoMediumItalic = "Roboto-MediumItalic"
    case robotoBold = "Roboto-Bold"
    case robotoBoldItalic = "Roboto-BoldItalic"
    case robotoRegular = "Roboto-Regular"
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
    
    // MARK: - Roboto Medium Bold Italic
    static var robotoBoldItalic24: UIFont {
        guard let font = UIFont(name: FontName.robotoBoldItalic.rawValue, size: 24.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 24.0, weight: .bold)
        }
        return font
    }
    
    static var robotoMedium14: UIFont {
        guard let font = UIFont(name: FontName.robotoMedium.rawValue, size: 14.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight(rawValue: 600) )
        }
        return font
    }
    
    static var robotoMediumItalic24: UIFont {
        guard let font = UIFont(name: FontName.robotoMediumItalic.rawValue, size: 24.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight(rawValue: 600) )
        }
        return font
    }
    
    static var robotoMediumItalic14: UIFont {
        guard let font = UIFont(name: FontName.robotoMediumItalic.rawValue, size: 14.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight(rawValue: 600) )
        }
        return font
    }
    
    static var robotoBold14: UIFont {
        guard let font = UIFont(name: FontName.robotoBold.rawValue, size: 14.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight(rawValue: 700) )
        }
        return font
    }
    
    static var robotoRegular24: UIFont {
        guard let font = UIFont(name: FontName.robotoRegular.rawValue, size: 24.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight(rawValue: 400) )
        }
        return font
    }
    
    static var robotoRegular14: UIFont {
        guard let font = UIFont(name: FontName.robotoRegular.rawValue, size: 14.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight(rawValue: 400) )
        }
        return font
    }
    
    static var robotoRegular11: UIFont {
        guard let font = UIFont(name: FontName.robotoRegular.rawValue, size: 11.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight(rawValue: 400) )
        }
        return font
    }
    
    static var robotoRegular12: UIFont {
        guard let font = UIFont(name: FontName.robotoRegular.rawValue, size: 12.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight(rawValue: 400) )
        }
        return font
    }
    
    static var robotoRegular16: UIFont {
        guard let font = UIFont(name: FontName.robotoRegular.rawValue, size: 16.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight(rawValue: 400) )
        }
        return font
    }
}
