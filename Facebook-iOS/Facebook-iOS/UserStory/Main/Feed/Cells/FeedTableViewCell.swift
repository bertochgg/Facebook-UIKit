//
//  FeedTableViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import UIKit

protocol FeedTableViewCellProtocol {
    func shareButtonTapped()
    func likeButtonTapped()
}

class FeedTableViewCell: UITableViewCell {
    
    static let identifier = "FeedTableViewCell"
    private let images: [UIImage?] = [ImagesNames.profile, ImagesNames.profile, ImagesNames.profile]
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .white
        return image
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium14
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var creationTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.robotoRegular11
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var privacyImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.font = UIFont.robotoRegular12
        textView.isScrollEnabled = false
        return textView
    }()
    
    // Image Slider
    private lazy var imageSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemPurple
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.register(ImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(ImagesNames.share, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var likeButton: UIButton = {
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
        // imageSlider.rowHei
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
        creationTimeLabel.text = nil
        privacyImage.image = nil
        messageTextView.text = nil
    }
    
    public func configure(feedViewModel: FeedTableViewCellViewModel) {
        
        guard let safePostImageURL = feedViewModel.profileImageView else { return }
        let safeUsername = feedViewModel.usernameLabel
        guard let safeCreationTime = feedViewModel.creationTimeLabel else { return }
        guard let safeProfileImageURL = feedViewModel.profileImageView else { return }
        guard let safeMessage = feedViewModel.messageTextView else { return }
        
        DispatchQueue.main.async {
            self.profileImageView.downloadImage(from: safeProfileImageURL)
            self.usernameLabel.text = safeUsername
            self.creationTimeLabel.text = self.dateFormatting(date: safeCreationTime)
            self.privacyImage.image = UIImage(named: "Privacy Icon")
            self.messageTextView.text = safeMessage
        }
    }
    
    private func dateFormatting(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMM dd, yyyy"
        
        let formattedDate = outputDateFormatter.string(from: date)
        
        return formattedDate
    }
    
    private func setupLayout() {
        contentView.addSubview(profileImageView)
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
//        self.contentView.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
//        self.contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 380).isActive = true
        
        profileImageView.anchor(top: contentView.topAnchor,
                                left: contentView.leftAnchor,
                                paddingTop: 15, paddingLeft: 21,
                                width: 50, height: 50)
        
        usernameLabel.anchor(top: contentView.topAnchor,
                             left: profileImageView.rightAnchor,
                             right: contentView.rightAnchor,
                             paddingTop: 15, paddingLeft: 16, paddingRight: 129)
        
        creationTimeLabel.anchor(top: usernameLabel.bottomAnchor,
                                 left: profileImageView.rightAnchor,
                                 paddingTop: 2, paddingLeft: 16)
        
        privacyImage.anchor(top: usernameLabel.bottomAnchor,
                            left: creationTimeLabel.rightAnchor,
                            paddingTop: 4, paddingLeft: 8,
                            width: 9, height: 9)
        
        messageTextView.anchor(top: profileImageView.bottomAnchor,
                               left: contentView.leftAnchor,
                               right: contentView.rightAnchor,
                               paddingTop: 17, paddingLeft: 21, paddingRight: 21)
        
        imageSlider.anchor(top: messageTextView.bottomAnchor,
                           left: contentView.leftAnchor,
                           right: contentView.rightAnchor,
                           paddingTop: 5)
        imageSlider.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
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
    func shareButtonTapped() {
        
    }
    
    @objc
    func likeButtonTapped() {
        
    }
}

extension FeedTableViewCell: UICollectionViewDelegateFlowLayout {
    
}

extension FeedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSliderCollectionViewCell.identifier,
                                                            for: indexPath) as? ImageSliderCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item < images.count {
            if let safeImage = images[indexPath.row] {
                cell.configure(with: safeImage)
            }
        } else {
            cell.isHidden = true
        }
        
        return cell
    }
    
}
