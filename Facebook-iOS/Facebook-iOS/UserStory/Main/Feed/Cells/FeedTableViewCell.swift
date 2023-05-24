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
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemPurple
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
        // If you are adding elements to a cell we need to use content view to assign constraints to cell, if not we are adding constraints to cell
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
        
        // Set constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        creationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        privacyImage.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        imageSlider.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Profile Image View
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Username Label
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -129),
            
            // Creation Time Label
            creationTimeLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            creationTimeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            
            // Privacy Image
            privacyImage.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            privacyImage.leadingAnchor.constraint(equalTo: creationTimeLabel.trailingAnchor, constant: 8),
            privacyImage.widthAnchor.constraint(equalToConstant: 9),
            privacyImage.heightAnchor.constraint(equalToConstant: 9),
            
            // Message Text View
            messageTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 17),
            messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 14),
            
            // Image Slider
            imageSlider.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 5),
            imageSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageSlider.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -10),
            imageSlider.heightAnchor.constraint(equalToConstant: 250),
            
            // Share Button
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            shareButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            shareButton.widthAnchor.constraint(equalToConstant: 24),
            shareButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Like Button
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            likeButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 20),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupActions() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
}

extension FeedTableViewCell: FeedTableViewCellProtocol {
    @objc
    func shareButtonTapped() {
        imageSlider.isHidden = true
    }
    
    @objc
    func likeButtonTapped() {
        imageSlider.isHidden = false
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
            return UICollectionViewCell()
        }
        
        if indexPath.item < images.count {
            if let safeImage = images[indexPath.item] {
                cell.configure(with: safeImage)
            }
        } else {
            cell.isHidden = true
        }
        
        return cell
    }
    
}
