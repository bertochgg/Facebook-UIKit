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
    
    static var identifier: String { return String(describing: self) }
    private var dataSource: UICollectionViewDiffableDataSource<Int, URL>?
    private var messageTextViewHeightConstraint: NSLayoutConstraint?
    private var imageSliderHeightConstraint: NSLayoutConstraint?
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .white
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMediumItalic14
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var creationTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.creationTimeGrayTextColor
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
        textView.isEditable = false
        return textView
    }()
    
    // Image Slider
    private lazy var imageSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemPurple
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.currentPageIndicatorTintColor = .blue
        page.pageIndicatorTintColor = .lightGray
        return page
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
        
        imageSlider.delegate = self
        
        setupLayout()
        setupConstraints()
        setupActions()
        
        configureDataSource()
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
        profileImageView.image = nil
        usernameLabel.text = nil
        creationTimeLabel.text = nil
        privacyImage.image = nil
        messageTextView.text = nil
    }
    
    public func configure(with viewModel: FeedTableViewCellViewModel) {
        guard let safeProfileImageURL = URL(string: viewModel.profileImageURL) else { return }
        self.profileImageView.downloadImage(from: safeProfileImageURL)
        self.usernameLabel.text = viewModel.username
        self.creationTimeLabel.text = viewModel.creationTime
        self.privacyImage.image = ImagesNames.privacy
        
        // Configure message label
        if let message = viewModel.message, !message.isEmpty {
            self.messageTextView.text = message
            self.messageTextView.isHidden = false
            self.messageTextViewHeightConstraint?.isActive = false
        } else {
            self.messageTextView.isHidden = true
            self.messageTextViewHeightConstraint = messageTextView.heightAnchor.constraint(equalToConstant: 0)
            self.messageTextViewHeightConstraint?.constant = 0
            self.messageTextViewHeightConstraint?.isActive = true
        }
        
        // Configure image slider
        if viewModel.imageURL != nil || !viewModel.imageURLs.isEmpty {
            self.imageSlider.isHidden = false
            self.pageControl.isHidden = false
            self.imageSliderHeightConstraint?.constant = 250
        } else {
            self.imageSlider.isHidden = true
            self.pageControl.isHidden = true
            self.imageSliderHeightConstraint?.isActive = false
            self.imageSliderHeightConstraint?.constant = 0
            self.imageSliderHeightConstraint?.isActive = true
        }
        
        applySnapshot(with: viewModel)
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = viewModel.imageURLs.count
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
        contentView.addSubview(pageControl)
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
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Profile Image View
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Username Label
        usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -129).isActive = true
        
        // Creation Time Label
        creationTimeLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2).isActive = true
        creationTimeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        
        // Privacy Image
        privacyImage.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4).isActive = true
        privacyImage.leadingAnchor.constraint(equalTo: creationTimeLabel.trailingAnchor, constant: 8).isActive = true
        privacyImage.widthAnchor.constraint(equalToConstant: 9).isActive = true
        privacyImage.heightAnchor.constraint(equalToConstant: 9).isActive = true
        
        // Message Text View
        messageTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 17).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21).isActive = true
        //            messageTextView.bottomAnchor.constraint(greaterThanOrEqualTo: imageSlider.topAnchor, constant: -5), // Allows dynamic height based on content
        
        // Image Slider
        imageSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageSlider.topAnchor.constraint(greaterThanOrEqualTo: messageTextView.bottomAnchor, constant: 5).isActive = true
        imageSlider.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -10).isActive = true
        self.imageSliderHeightConstraint = imageSlider.heightAnchor.constraint(equalToConstant: 250)
        self.imageSliderHeightConstraint?.isActive = true
        
        // Page Control
        pageControl.centerXAnchor.constraint(equalTo: imageSlider.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: imageSlider.bottomAnchor, constant: -10).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // Share Button
        shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Like Button
        likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 20).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
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
        highlightButton()
    }
    
    private func highlightButton() {
        let highlightedImage = likeButton.currentImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        likeButton.setImage(highlightedImage, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.likeButton.setImage(self.likeButton.currentImage?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
}

extension FeedTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = contentView.frame.size.width
        return CGSize(width: width, height: contentView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
}

extension FeedTableViewCell: UICollectionViewDelegate {
    
}

extension FeedTableViewCell {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, URL>(collectionView: imageSlider) { collectionView, indexPath, url in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSliderCollectionViewCell.identifier,
                                                                for: indexPath) as? ImageSliderCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let imageURLs = CarouselCellViewModel(imageURL: url)
            cell.configure(with: imageURLs)
            
            return cell
        }
    }
    
    func applySnapshot(with viewModel: FeedTableViewCellViewModel) {
        guard let dataSource = dataSource else { return }
        guard let validURL = viewModel.imageURL else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, URL>()
        snapshot.appendSections([0])
        
        let validURLs = viewModel.imageURLs.compactMap { $0 }
        
        snapshot.appendItems([validURL]) // Append the validURL first
        snapshot.appendItems(validURLs) // Then append the validURLs
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
