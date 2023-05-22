//
//  ImageSliderCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 22/05/23.
//

import UIKit

class ImageSliderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "imageSliderCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image
    }
}
