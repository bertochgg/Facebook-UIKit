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
}

protocol ProfileLogoutDelegate: AnyObject {
    func didLogoutTapped()
}

protocol ProfileViewProtocolDelegates {
    func didTapAddPost()
    func didTakePhotoButtonTapped()
}

private protocol ProfileViewProtocol {
    var delegate: ProfileLogoutDelegate? { get set }
    
    var customProfileImage: CustomImageView { get }
    var customCameraImageButton: CustomProfileButtons { get }
    var backgroundImageView: CustomImageView { get }
    var addPostButton: CustomProfileButtons { get }
    var logoutButton: CustomProfileButtons { get }
    var usernameLabel: CustomProfileLabel { get }
    var userBioTextView: UITextView { get set }
    
    var containerView: UIView { get }
    var subContainerView: UIView { get }
}

protocol ProfileViewActionsProtocol {
    func addPostsButtonTapped()
    func logoutButtonTapped()
    func takePhotoButtonTapped()
}

class ProfileView: UIView, ProfileViewProtocol, ProfileViewActionsProtocol {
    
    weak var delegate: ProfileLogoutDelegate?
    
    var profileImageURL: URL? {
        didSet {
            if let imageURL = profileImageURL {
                customProfileImage.downloadImage(from: imageURL)
            }
        }
    }
    
    var backgroundImageURL: URL? {
        didSet {
            guard let imageURL = backgroundImageURL else { return }
            backgroundImageView.downloadImage(from: imageURL)
        }
    }
    
    var username: String? {
        didSet {
            usernameLabel.text = username
        }
    }
    
    var userBio: (text: String, email: String)? {
        didSet {
            guard let text = userBio?.text, let email = userBio?.email else { return }
            let bioText = text + " " + email
            let highlightText = NSMutableAttributedString(string: bioText)
            let linkRange = (bioText as NSString).range(of: email)
            highlightText.addAttribute(.link, value: email, range: linkRange)
            highlightText.addAttribute(.foregroundColor, value: UIColor.blue, range: linkRange)
            userBioTextView.delegate = self
            userBioTextView.attributedText = highlightText
        }
    }
    
    fileprivate let customProfileImage = CustomImageView(frame: .zero)
    fileprivate let customCameraImageButton = CustomProfileButtons(frame: .zero)
    fileprivate let backgroundImageView = CustomImageView(frame: .zero)
    
    fileprivate let addPostButton = CustomProfileButtons(frame: .zero)
    fileprivate let logoutButton = CustomProfileButtons(frame: .zero)
    
    fileprivate let usernameLabel = CustomProfileLabel(frame: .zero)
    fileprivate var userBioTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor)
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
        
        mainView.addSubview(customProfileImage)
        customProfileImage.setupImageView(image: UIImage(named: Constants.profileImageName),
                                          radius: 25,
                                          borderWidth: 5,
                                          borderColor: .white)
        mainView.addSubview(customCameraImageButton)
        if let cameraIcon = ImagesNames.camera {
            customCameraImageButton.setupButtonWithImge(image: cameraIcon,
                                                        backgroundColor: Constants.takeProfileImageCameraBackgroundColor,
                                                        radius: 7,
                                                        opacity: 0.7,
                                                        tintColor: Constants.takeProfileImageCameraIconColor)
        }
        
        customCameraImageButton.contentEdgeInsets = UIEdgeInsets(top: 8.25, left: 4, bottom: 2.6, right: 4)
        
        customProfileImage.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        customProfileImage.anchor(top: mainView.topAnchor, paddingTop: 190, width: 180, height: 180)
        customCameraImageButton.anchor(bottom: customProfileImage.bottomAnchor,
                                       right: customProfileImage.rightAnchor,
                                       paddingBottom: 16,
                                       paddingRight: 16,
                                       width: 25,
                                       height: 25)
        customCameraImageButton.addTarget(self, action: #selector(takePhotoButtonTapped), for: .touchUpInside)
        
        mainView.addSubview(usernameLabel)
        usernameLabel.setupLabel(font: UIFont.robotoRegular24,
                                 textColor: .black,
                                 backgroundColor: .clear)
        usernameLabel.numberOfLines = 1
        usernameLabel.anchor(top: customProfileImage.bottomAnchor,
                             left: mainView.leftAnchor,
                             right: mainView.rightAnchor,
                             paddingTop: 15, paddingLeft: 27, paddingRight: 75)
        
        mainView.addSubview(userBioTextView)
        userBioTextView.font = UIFont.robotoRegular14
        userBioTextView.textColor = .black
        userBioTextView.backgroundColor = .clear
        userBioTextView.placeholder = "Share who you are"
        userBioTextView.placeholderColor = .gray
        let padding = userBioTextView.textContainer.lineFragmentPadding
        userBioTextView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        userBioTextView.isEditable = true
        userBioTextView.isSelectable = true
        userBioTextView.anchor(top: usernameLabel.bottomAnchor,
                               left: mainView.leftAnchor,
                               right: mainView.rightAnchor,
                               paddingTop: 11, paddingLeft: 29, paddingRight: 18, height: 56)
        
        return mainView
    }()
    
    lazy var subContainerView: UIView = {
        let subView = UIView()
        guard let safeHeaderBackgroundImage = UIImage(named: Constants.headerBackgroundImageName) else {
            return subView
        }
        
        subView.addSubview(backgroundImageView)
        backgroundImageView.setupImageView(image: UIImage(named: Constants.headerBackgroundImageName), radius: 0, borderWidth: 0, borderColor: .clear)
        backgroundImageView.anchor(top: subView.topAnchor, left: subView.leftAnchor, bottom: subView.bottomAnchor, right: subView.rightAnchor)
        
        subView.addSubview(addPostButton)
        addPostButton.setupButton(title: "Add Post",
                                  font: UIFont.robotoBold14,
                                  textColor: .white,
                                  backgroundColor: .clear,
                                  radius: 0)
        addPostButton.addTarget(self, action: #selector(addPostsButtonTapped), for: .touchUpInside)
        addPostButton.anchor(top: subView.topAnchor, left: subView.leftAnchor, paddingTop: 35, paddingLeft: 22)
        
        subView.addSubview(logoutButton)
        if let logoutImage = ImagesNames.logout {
            logoutButton.setupButtonWithImge(image: logoutImage,
                                             backgroundColor: .clear,
                                             radius: 0,
                                             opacity: 1,
                                             tintColor: .white)
        }
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.anchor(top: subView.topAnchor,
                            right: subView.rightAnchor,
                            paddingTop: 28,
                            paddingRight: 24, width: 24, height: 24)
        
        return subView
    }()
    
    @objc
    func addPostsButtonTapped() {
        print("posts")
    }
    
    @objc
    func logoutButtonTapped() {
        print("logout")
        self.delegate?.didLogoutTapped()
    }
    
    @objc
    func takePhotoButtonTapped() {
        print("taking photo...")
    }
    
}

extension ProfileView: UITextViewDelegate {
    
}
