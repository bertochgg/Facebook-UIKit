//
//  CustomImageView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 11/05/23.
//

import UIKit

class CustomImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupImageView(image: UIImage?, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.image = image
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
    }
    
    func setupChildImageView(image: UIImage?, radius: CGFloat, backgroundColor: UIColor, opacity: Float, imageColor: UIColor) {
        self.image = image
        self.layer.cornerRadius = radius
        self.backgroundColor = backgroundColor
        self.tintColor = imageColor
        self.layer.opacity = opacity
        self.contentMode = .center
        self.clipsToBounds = true
        
    }
    
}
