//
//  CustomImageView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 11/05/23.
//

import UIKit

private enum Constants {
    static let profileImageName = "Profile image"
    static let headerBackgroundImageName = "Header Background Image"
}

class CustomImageView: UIImageView {
    
//    private let imageView: UIImageView = UIImageView()
    private let childImageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func setupCustomImageView() {
//        setupImageViewWithChildImage(image: UIImage(named: Constants.profileImageName),
//                                     radius: 25,
//                                     borderWidth: 13,
//                                     borderColor: .white,
//                                     hasChildImage: true)
//    }
    
    func setupImageViewWithChildImage(image: UIImage?, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, hasChildImage: Bool) {
        self.image = image
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        if hasChildImage {
            setupChildImageView(image: UIImage(systemName: "camera.fill"),
                                radius: 7,
                                opacity: 0.7)
        } else {
            childImageView.isHidden = true
        }
    }
    
    private func setupChildImageView(image: UIImage?, radius: CGFloat, opacity: Float) {
        childImageView.image = image
        childImageView.layer.cornerRadius = radius
        childImageView.layer.opacity = opacity
    }
    
}
