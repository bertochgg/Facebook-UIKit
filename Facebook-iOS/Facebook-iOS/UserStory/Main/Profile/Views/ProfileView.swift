//
//  ProfileView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 11/05/23.
//

import UIKit

private enum Constants {
    static let profileImageName = "Profile image"
    static let headerBackgroundImageName = "Header Background Image"
}

class ProfileView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var containerView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .systemBlue
        
        mainView.addSubview(subContainerView)
        
        subContainerView.anchor(top: mainView.safeAreaLayoutGuide.topAnchor, left: mainView.leftAnchor, right: mainView.rightAnchor, height: 220)
        return mainView
    }()
    
    lazy var subContainerView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .yellow
        
        subView.addSubview(customProfileImage)
        customProfileImage.setupImageViewWithChildImage(image: UIImage(named: Constants.profileImageName),
                                                        radius: 25,
                                                        borderWidth: 8,
                                                        borderColor: .white,
                                                        hasChildImage: true)
        customProfileImage.translatesAutoresizingMaskIntoConstraints = false
        customProfileImage.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        customProfileImage.centerYAnchor.constraint(equalTo: subView.centerYAnchor).isActive = true
        customProfileImage.widthAnchor.constraint(equalToConstant: 180).isActive = true
        customProfileImage.heightAnchor.constraint(equalToConstant: 180).isActive = true
        return subView
    }()
    
    private let customProfileImage = CustomImageView(frame: .zero)
    
    private let headerBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setupImageView(image: UIImage(named: Constants.headerBackgroundImageName),
                                 radius: 0,
                                 borderWidth: 0,
                                 borderColor: .clear)
        return imageView
    }()
    
}
