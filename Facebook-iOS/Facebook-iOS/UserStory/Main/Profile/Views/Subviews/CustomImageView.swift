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

    private let childImageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageViewWithChildImage(image: UIImage?, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, hasChildImage: Bool) {
        self.image = image
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.contentMode = .scaleToFill
        self.clipsToBounds = true
        
        if hasChildImage {
            addSubview(childImageView)
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
        
        childImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childImageView.leftAnchor.constraint(equalTo: rightAnchor, constant: -5),
            childImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            childImageView.widthAnchor.constraint(equalToConstant: 200),
            childImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}
