//
//  CustomProfileButtons.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 17/05/23.
//

import UIKit

protocol CustomProfileButtonsProtocol {
    func setupButton(title: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor, radius: CGFloat)
    func setupButtonWithImge(image: UIImage, backgroundColor: UIColor, radius: CGFloat, opacity: Float, tintColor: UIColor)
}
class CustomProfileButtons: UIButton, CustomProfileButtonsProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton(title: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor, radius: CGFloat) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.titleLabel?.textColor = textColor
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
    }
    
    func setupButtonWithImge(image: UIImage, backgroundColor: UIColor, radius: CGFloat, opacity: Float, tintColor: UIColor) {
        self.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        self.layer.opacity = opacity
        self.tintColor = tintColor
    }

}
