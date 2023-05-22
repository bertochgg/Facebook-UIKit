//
//  FeedTableViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import UIKit

private protocol FeedTableViewCellProtocol {
    func shareButtonTapped()
    func likeButtonTapped()
}

class FeedTableViewCell: UITableViewCell {
    
    static let identifier = "FeedTableViewCell"
    private let images: [UIImage] = []
    
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
    
    // Image Slider
    private let imageSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.register(ImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(ImagesNames.share, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImagesNames.like, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
        
        imageSlider.delegate = self
        imageSlider.dataSource = self
        
        setupLayout()
        setupConstraints()
        setupActions()
        
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
    }
    
    public func configure(feedModel: FeedTableViewCellViewModel, profileModel: UserProfileData) {
        guard let safePostImageURL = feedModel.post.data.first?.attachments?.data.first?.media?.image?.src else { return }
        let safeUsername = profileModel.firstName + " " + profileModel.lastName
        guard let safeCreationTime = feedModel.post.data.first?.createdTime else { return }
        guard let safeProfileImageURL = URL(string: profileModel.picture.data.url) else { return }
        guard let safeMessage = feedModel.post.data.first?.message else { return }
        
        
        DispatchQueue.main.async {
            self.profileImage.downloadImage(from: safeProfileImageURL)
            self.usernameLabel.text = safeUsername
            self.creationTimeLabel.text = self.dateFormattingWithISO8601(date: safeCreationTime)
            self.privacyImage.downloadImage(from: safePostImageURL)
            self.messageTextView.text = safeMessage
        }
    }
    
    private func dateFormattingWithISO8601(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func setupLayout() {
        contentView.addSubview(profileImage)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(creationTimeLabel)
        contentView.addSubview(privacyImage)
        contentView.addSubview(messageTextView)
        // Image Slider -> Collection View
        contentView.addSubview(imageSlider)
        // Social Buttons
        contentView.addSubview(shareButton)
        contentView.addSubview(likeButton)
        
    }
    
    private func setupConstraints() {
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
        
        imageSlider.anchor(top: messageTextView.bottomAnchor,
                           left: contentView.leftAnchor,
                           right: contentView.rightAnchor,
                           paddingTop: 5,
                           height: 250)
        
        shareButton.anchor(top: imageSlider.bottomAnchor, left: leftAnchor,
                           paddingTop: 10, paddingLeft: 20,
                           width: 24, height: 24)
        
        likeButton.anchor(top: imageSlider.bottomAnchor, left: shareButton.rightAnchor,
                          paddingTop: 10, paddingLeft: 20,
                          width: 24, height: 24)
        
    }
    
    private func setupActions() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
}

extension FeedTableViewCell: FeedTableViewCellProtocol {
    @objc
    fileprivate func shareButtonTapped() {
        
    }
    
    @objc
    fileprivate func likeButtonTapped() {
        
    }
}

extension FeedTableViewCell: UICollectionViewDelegateFlowLayout {
    
}

extension FeedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSliderCollectionViewCell.identifier,
                                                            for: indexPath) as? ImageSliderCollectionViewCell else {
            fatalError("Unable to dequeue MyImageCollectionViewCell")
        }
        let image = images[indexPath.item]
        cell.configure(with: image)
        return cell
    }
    
}
