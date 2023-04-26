//
//  UIColor+Extension.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/27/22.
//

import UIKit

extension UIColor {
    
    @nonobjc class var facebookBlue: UIColor {
        // #4267b2 = rgba(66,103,178,255)
        return UIColor(hexString: "#4267b2") ?? .blue
    }
    
    class var facebookLoginButtonBlue: UIColor {
        
        return UIColor(hexString: "#1877F2") ?? .blue
    }
    
    
}
