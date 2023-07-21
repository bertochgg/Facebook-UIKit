//
//  UIColor+Extension.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/27/22.
//

import UIKit

extension UIColor {
    
    class var facebookBlue: UIColor {
        // #4267b2 = rgba(66,103,178,255)
        return UIColor(hexString: "#4267b2") ?? .blue
    }
    
    class var facebookLoginButtonBlue: UIColor {
        
        return UIColor(hexString: "#1877F2") ?? .blue
    }
    
    class var takeProfileImageGrayColor: UIColor {
        return UIColor(hexString: "#DDDDDD") ?? .gray
    }
    
    class var profileCameraIconBackgroundColor: UIColor {
        return UIColor(hexString: "#000000") ?? .black
    }
    
    class var creationTimeGrayTextColor: UIColor {
        return UIColor(hexString: "#999999") ?? .gray
    }
    
    class var createPostMessageTextViewColor: UIColor {
        return UIColor(hexString: "#EEEEEE") ?? .gray
    }
    
    class var createPostMessageTextViewPlaceholder: UIColor {
        return UIColor(hexString: "#C4C4C4") ?? .gray
    }
    
}
