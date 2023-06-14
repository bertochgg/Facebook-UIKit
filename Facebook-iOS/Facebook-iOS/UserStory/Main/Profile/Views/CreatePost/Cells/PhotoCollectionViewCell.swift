//
//  PhotoCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 13/06/23.
//

import UIKit

protocol PhotoCollectionViewCellDelegate: AnyObject {
    func didTapAddPhotoButton()
}

struct PhotoCollectionViewCellViewModel: Hashable {
    let id = UUID()
    let image: UIImage
}

class PhotoCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    weak var delegate: PhotoCollectionViewCellDelegate?
    private lazy var views = [
        postImageView,
        placeholderImageView,
        addPhotoButton
    ]
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .createPostMessageTextViewPlaceholderColor
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhotoButtonTapped))
        imageView.addGestureRecognizer(tapGesture)
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
        let button = UIButton(type: .system)
        button.setImage(ImagesNames.addPhotoIcon, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        views.forEach { view in
            contentView.addSubview(view)
        }
        postImageView.frame = contentView.bounds
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    func configure(with viewModel: PhotoCollectionViewCellViewModel) {
        if viewModel.image == ImagesNames.placeholderImage {
            postImageView.isHidden = false
            placeholderImageView.isHidden = false
            addPhotoButton.isHidden = false
        } else {
            postImageView.isHidden = false
            placeholderImageView.isHidden = true
            addPhotoButton.isHidden = true
            postImageView.image = viewModel.image
        }
    }
    
    private func setupConstraints() {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.placeholderImageView.anchor(top: postImageView.topAnchor,
                                         left: postImageView.leftAnchor,
                                         bottom: postImageView.bottomAnchor,
                                         right: postImageView.rightAnchor,
                                         paddingTop: 25, paddingLeft: 25, paddingBottom: 25, paddingRight: 25)
        self.addPhotoButton.anchor(bottom: postImageView.bottomAnchor, right: postImageView.rightAnchor,
                                   paddingBottom: 6, paddingRight: 6,
                                   width: 24, height: 24)
    }
    
    @objc
    private func addPhotoButtonTapped() {
        print("Adding new photo")
        self.delegate?.didTapAddPhotoButton()
    }

}
