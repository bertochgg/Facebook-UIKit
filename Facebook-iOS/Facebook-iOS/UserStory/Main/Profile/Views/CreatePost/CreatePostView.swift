//
//  CreatePostView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//

import UIKit
import UITextView_Placeholder

class CreatePostView: UIView {
    
    private lazy var views = [
        profileImageView,
        usernameLabel,
        messageTextView,
        postImageView,
        placeholderImageView,
        addPhotoButton
    ]
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium14
        label.textColor = .black
        label.text = "Brum Brum"
        return label
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.backgroundColor = UIColor.createPostMessageTextViewColor.withAlphaComponent(0.5)
        textView.alpha = 1
        textView.textColor = .black
        textView.placeholder = "What's on your mind?"
        textView.placeholderColor = UIColor.createPostMessageTextViewPlaceholderColor
        textView.font = UIFont.robotoRegular16
        textView.textContainerInset = UIEdgeInsets(top: 12,
                                                   left: 13,
                                                   bottom: 12,
                                                   right: 10)
        textView.delegate = self
        return textView
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = UIColor.createPostMessageTextViewPlaceholderColor
        return imageView
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.image = ImagesNames.placeholderImage
        return imageView
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(ImagesNames.addPhotoIcon, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupViews() {
        self.views.forEach { view in
            addSubview(view)
        }
    }
    
    private func setupConstraints() {
        self.views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
                                     paddingTop: 17, paddingLeft: 16,
                                     width: 50, height: 50)
        self.usernameLabel.anchor(top: safeAreaLayoutGuide.topAnchor,
                                  left: profileImageView.rightAnchor,
                                  right: rightAnchor,
                                  paddingTop: 34, paddingLeft: 10, paddingRight: 160)
        self.messageTextView.anchor(top: profileImageView.bottomAnchor,
                                    left: leftAnchor,
                                    right: rightAnchor,
                                    paddingTop: 11, paddingLeft: 13, paddingRight: 13,
                                    height: 232)
        self.postImageView.anchor(top: messageTextView.bottomAnchor, left: leftAnchor,
                                  paddingTop: 23, paddingLeft: 16,
                                  width: 90, height: 90)
        self.placeholderImageView.anchor(top: postImageView.topAnchor,
                                         left: postImageView.leftAnchor,
                                         bottom: postImageView.bottomAnchor,
                                         right: postImageView.rightAnchor,
                                         paddingTop: 25, paddingLeft: 25, paddingBottom: 25, paddingRight: 25)
        self.addPhotoButton.anchor(bottom: postImageView.bottomAnchor, right: postImageView.rightAnchor,
                                   paddingBottom: 6, paddingRight: 6,
                                   width: 24, height: 24)
    }
}

extension CreatePostView: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
    }
}
