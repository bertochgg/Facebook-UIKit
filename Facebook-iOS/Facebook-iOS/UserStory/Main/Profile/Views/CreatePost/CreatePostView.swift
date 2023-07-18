//
//  CreatePostView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//

import UIKit
import UITextView_Placeholder

class CreatePostView: UIView {
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    private var diffableDataSource: CreatePostDataSource?
    private lazy var views = [
        profileImageView,
        usernameLabel,
        messageTextView,
        photoCarousel
    ]
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium14
        label.textColor = .black
        return label
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .createPostMessageTextViewColor.withAlphaComponent(0.5)
        textView.alpha = 1
        textView.textColor = .black
        textView.placeholder = "What's on your mind?"
        textView.placeholderColor = .createPostMessageTextViewPlaceholderColor
        textView.font = .robotoRegular16
        textView.textContainerInset = UIEdgeInsets(top: 12,
                                                   left: 13,
                                                   bottom: 12,
                                                   right: 10)
        textView.doneAccessory = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var photoCarousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 33 // Vertical spacing
        layout.minimumInteritemSpacing = 33 // Horizontal spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        collectionView.addGestureRecognizer(tapGesture)
        return collectionView
    }()
    
    init(frame: CGRect, delegate: PhotoCollectionViewCellDelegate?) {
        super.init(frame: frame)
        self.delegate = delegate
        diffableDataSource = CreatePostDataSource(collectionView: photoCarousel, delegate: delegate)
        photoCarousel.delegate = self
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
    
    func configure(with viewModel: CreatePostDataViewModel) {
        if let safeImageURL = viewModel.profileImageURL {
            self.profileImageView.downloadImage(from: safeImageURL)
        } else {
            self.profileImageView.image = ImagesNames.defaultProfileImage
        }
        
        if let safeUsername = viewModel.username {
            self.usernameLabel.text = safeUsername
        } else {
            self.usernameLabel.text = "Username"
        }
    }
    
    func isMessageTextViewEmpty() -> Bool {
        return messageTextView.text.isEmpty
    }
    
    func isPhotoCarouselEmpty() -> Bool {
        return photoCarousel.numberOfItems(inSection: 0) == 0
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
        
        self.photoCarousel.anchor(top: messageTextView.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor,
                                  paddingTop: 9)
    }
    
    private func dismissKeyboardForTextView() {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
    }
    
    @objc
    private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        self.dismissKeyboardForTextView()
    }
}

extension CreatePostView: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboardForTextView()
    }
}

extension CreatePostView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (photoCarousel.frame.size.width / 4) - 2,
            height: (photoCarousel.frame.size.width / 4) - 1
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 14, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // do something when a cell is tapped
    }
}

extension CreatePostView {
    func applySnapshot(with viewModels: [PhotoCollectionViewCellViewModel]) {
        diffableDataSource?.update(with: viewModels)
    }
}
