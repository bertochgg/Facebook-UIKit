//
//  FeedTableViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let identifier = "FeedTableViewCell"
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium14
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let creationTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.robotoRegular11
        label.numberOfLines = 1
        return label
    }()
    
    private let privacyImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.font = UIFont.robotoRegular12
        return textView
    }()
    
    private let postImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // Image Slider
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // myData.post.data.first?.attachments?.data.first?.media?.image?.src
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        usernameLabel.text = nil
        creationTimeLabel.text = nil
        privacyImage.image = nil
        messageTextView.text = nil
        postImage.image = nil
    }
    
    public func configure(feedModel: FeedTableViewCellViewModel, profileModel: UserProfileData) {
        guard let safePostImageURL = feedModel.post.data.first?.attachments?.data.first?.media?.image?.src else { return }
        guard let safeProfileImageURL = URL(string: profileModel.picture.data.url) else { return }
        profileImage.downloadImage(from: safeProfileImageURL)
        usernameLabel.text = "nil"
        creationTimeLabel.text = "nil"
        privacyImage.downloadImage(from: safePostImageURL)
        messageTextView.text = "nil"
        postImage.downloadImage(from: safePostImageURL)
    }
    
    private func setupLayout() {
        contentView.addSubview(profileImage)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(creationTimeLabel)
        contentView.addSubview(privacyImage)
        contentView.addSubview(messageTextView)
        contentView.addSubview(postImage)
        
        // Constraints
        profileImage.anchor(top: contentView.topAnchor,
                            left: contentView.leftAnchor,
                            paddingTop: 15, paddingLeft: 21,
                            width: 50, height: 50)
        
        usernameLabel.anchor(top: contentView.topAnchor,
                             left: profileImage.rightAnchor,
                             right: contentView.rightAnchor,
                             paddingTop: 15, paddingLeft: 16, paddingRight: 129)
        
        creationTimeLabel.anchor(top: usernameLabel.bottomAnchor,
                                 left: profileImage.rightAnchor,
                                 right: contentView.rightAnchor,
                                 paddingTop: 2, paddingLeft: 16, paddingRight: 170)
        
        privacyImage.anchor(left: creationTimeLabel.rightAnchor,
                            paddingLeft: 9,
                            width: 9, height: 9)
        
        messageTextView.anchor(top: profileImage.bottomAnchor,
                               left: contentView.leftAnchor,
                               right: contentView.rightAnchor,
                               paddingTop: 17, paddingLeft: 21, paddingRight: 21)
        
        postImage.anchor(top: messageTextView.bottomAnchor,
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 5,
                         height: 250)
    }
    
}
