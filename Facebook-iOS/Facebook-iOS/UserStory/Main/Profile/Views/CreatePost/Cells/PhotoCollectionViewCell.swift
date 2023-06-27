//
//  PhotoCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 13/06/23.
//

import UIKit

protocol PhotoCollectionViewCellDelegate: AnyObject {
    func didTapAddPhotoButton(cell: PhotoCollectionViewCell)
    func didTapCancelImageButton(index: Int)
}

struct PhotoCollectionViewCellViewModel: Hashable {
    let id: UUID = UUID()
    let image: UIImage?
    let isPlaceholder: Bool
    
    init(image: UIImage?) {
        if image == ImagesNames.placeholderImage {
            self.isPlaceholder = true
            self.image = ImagesNames.placeholderImage
        } else {
            self.isPlaceholder = false
            self.image = image
        }
    }
}

class PhotoCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    weak var delegate: PhotoCollectionViewCellDelegate?
    private lazy var views = [
        postImageView,
        placeholderImageView,
        addPhotoButton,
        cancelImageButton
    ]
    private var index = 0
    
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
    
    private lazy var cancelImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(ImagesNames.cancelImageButton, for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .red
        button.addTarget(self, action: #selector(cancelImageButtonTapped), for: .touchUpInside)
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
    
    func configure(with viewModel: PhotoCollectionViewCellViewModel, index: Int) {
        self.index = index
        if viewModel.isPlaceholder {
            postImageView.isHidden = false
            placeholderImageView.isHidden = false
            placeholderImageView.image = viewModel.image
            addPhotoButton.isHidden = false
            cancelImageButton.isHidden = false
        } else {
            postImageView.isHidden = false
            placeholderImageView.isHidden = true
            addPhotoButton.isHidden = true
            postImageView.image = viewModel.image
            cancelImageButton.isHidden = false
            postImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editImage))
            postImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    private func setupConstraints() {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.postImageView.anchor(top: cancelImageButton.bottomAnchor,
                                  left: cancelImageButton.rightAnchor,
                                  bottom: contentView.bottomAnchor,
                                  right: contentView.rightAnchor,
                                  paddingTop: -6, paddingLeft: -6)
        self.placeholderImageView.anchor(top: postImageView.topAnchor,
                                         left: postImageView.leftAnchor,
                                         bottom: postImageView.bottomAnchor,
                                         right: postImageView.rightAnchor,
                                         paddingTop: 25, paddingLeft: 25, paddingBottom: 25, paddingRight: 25)
        self.addPhotoButton.anchor(bottom: postImageView.bottomAnchor, right: postImageView.rightAnchor,
                                   paddingBottom: 6, paddingRight: 6,
                                   width: 24, height: 24)
        self.cancelImageButton.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                                 paddingTop: 0, paddingLeft: 0,
                                 width: 18, height: 18)
    }
    
    @objc
    private func addPhotoButtonTapped() {
        print("Adding new photo")
        self.delegate?.didTapAddPhotoButton(cell: self)
    }
    
    @objc
    private func cancelImageButtonTapped() {
        print("deleting image")
        self.delegate?.didTapCancelImageButton(index: self.index)
    }
    
    @objc
    private func editImage() {
        print("I am editing image")
    }

}
