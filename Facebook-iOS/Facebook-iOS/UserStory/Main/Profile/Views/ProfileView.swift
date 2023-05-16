//
//  ProfileView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 11/05/23.
//
import UIKit
import UITextView_Placeholder

private enum Constants {
    static let profileImageName = "Profile image"
    static let headerBackgroundImageName = "Header Background Image"
    
    // Colors
    static let takeProfileImageCameraBackgroundColor = UIColor.takeProfileImageGrayColor
    static let takeProfileImageCameraIconColor = UIColor.profileCameraIconBackgroundColor
    
    // SF Symbols
}

protocol ProfileViewProtocol {
    func didTapLogout()
    func didTapAddPost()
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
        mainView.backgroundColor = .white
        
        mainView.addSubview(subContainerView)
        
        subContainerView.anchor(top: mainView.safeAreaLayoutGuide.topAnchor,
                                left: mainView.leftAnchor,
                                right: mainView.rightAnchor,
                                height: 250)
        return mainView
    }()
    
    lazy var subContainerView: UIView = {
        let subView = UIView()
        guard let safeHeaderBackgroundImage = UIImage(named: Constants.headerBackgroundImageName) else {
            return subView
        }
        
        subView.backgroundColor = UIColor(patternImage: safeHeaderBackgroundImage)
        subView.contentMode = .scaleAspectFill
        
        let customProfileImage = CustomImageView(frame: .zero)
        customProfileImage.isUserInteractionEnabled = true
        subView.addSubview(customProfileImage)
        customProfileImage.translatesAutoresizingMaskIntoConstraints = false
        customProfileImage.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        let cameraSymbolConfiguration = UIImage.SymbolConfiguration(scale: .small)
        customProfileImage.setupChildImageView(image: UIImage(systemName: "camera.fill", withConfiguration: cameraSymbolConfiguration),
                            radius: 7,
                            backgroundColor: Constants.takeProfileImageCameraBackgroundColor,
                            opacity: 0.7,
                            imageColor: Constants.takeProfileImageCameraIconColor)
        
        customProfileImage.anchor(top: subView.topAnchor, paddingTop: 130, width: 180, height: 180)
        
        subView.addSubview(addPostButton)
        addPostButton.anchor(top: subView.topAnchor, left: subView.leftAnchor, paddingTop: 35, paddingLeft: 22)
        
        subView.addSubview(logoutButton)
        logoutButton.anchor(top: subView.topAnchor,
                            right: subView.rightAnchor,
                            paddingTop: 32.25,
                            paddingRight: 28.25, width: 16.5, height: 15.5)
        
        subView.addSubview(usernameLabel)
        usernameLabel.anchor(top: subView.bottomAnchor, left: subView.leftAnchor, right: subView.rightAnchor, paddingTop: 75, paddingLeft: 27, paddingRight: 75)
        
        subView.addSubview(userBioText)
        userBioText.anchor(top: usernameLabel.bottomAnchor,
                           left: subView.leftAnchor,
                           right: subView.rightAnchor, paddingTop: 11, paddingLeft: 29, paddingRight: 18, height: 80)
        
        return subView
    }()
    
    lazy var addPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Post", for: .normal)
        button.titleLabel?.font = UIFont.robotoBold14
        button.titleLabel?.textColor = .white
        button.backgroundColor = .clear
        // Target action
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(ImagesNames.logout?.withRenderingMode(.alwaysOriginal), for: .normal)
        // Target action
        return button
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoRegular24
        label.textColor = .black
        label.text = "Name of the page"
        return label
    }()
    
    lazy var userBioText: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.robotoRegular14
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.placeholder = "Share who you are"
        textView.placeholderColor = .gray
        // Set the text and create an attributed string
        let bioText = "About text bla bla bla. Link to my web-site: https://www.youtube.com/ (up to 200 symbols)."
        let attributedString = NSMutableAttributedString(string: bioText)
        
        // Set the link attributes
        let linkRange = (bioText as NSString).range(of: "https://www.youtube.com/")
        attributedString.addAttribute(.link, value: "https://www.youtube.com/", range: linkRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: linkRange)
        
        // Delegate
        textView.delegate = self
        
        // Apply the attributed string to the text view
        textView.attributedText = attributedString
        textView.isEditable = true
        textView.isSelectable = true
        return textView
    }()
    
}

extension ProfileView: UITextViewDelegate {
    
}
