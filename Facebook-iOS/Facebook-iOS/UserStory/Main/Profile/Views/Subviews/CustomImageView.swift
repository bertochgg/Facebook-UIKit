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

protocol takeProfilePhotoDelegate: AnyObject {
    func didTakePhotoButtonTapped()
}

class CustomImageView: UIImageView {
    
    private let childImageViewAsButton = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageViewWithChildImage(image: UIImage(named: Constants.profileImageName),
                                     radius: 25,
                                     borderWidth: 10,
                                     borderColor: .white,
                                     hasChildImage: true)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedTakePhotoButton(_:)))
        childImageViewAsButton.isUserInteractionEnabled = true
        childImageViewAsButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        childImageViewAsButton.anchor(bottom: bottomAnchor,
                                      right: rightAnchor,
                                      paddingBottom: 21,
                                      paddingRight: 21,
                                      width: 26,
                                      height: 28)
    }
    
    func setupImageViewWithChildImage(image: UIImage?, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, hasChildImage: Bool) {
        self.image = image
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        if hasChildImage {
            addSubview(childImageViewAsButton)
        } else {
            childImageViewAsButton.isHidden = true
        }
    }
    
    func setupChildImageView(image: UIImage?, radius: CGFloat, backgroundColor: UIColor, opacity: Float, imageColor: UIColor) {
        childImageViewAsButton.image = image
        childImageViewAsButton.layer.cornerRadius = radius
        childImageViewAsButton.backgroundColor = backgroundColor
        childImageViewAsButton.tintColor = imageColor
        childImageViewAsButton.layer.opacity = opacity
        childImageViewAsButton.contentMode = .center
        
    }
    
    @objc
    func tappedTakePhotoButton(_ sender: UITapGestureRecognizer) {
        print("I'll take button")
    }
    
}
