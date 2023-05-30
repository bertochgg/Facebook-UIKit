//
//  ImageSliderCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 22/05/23.
//

import UIKit

class ImageSliderCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageSliderCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with viewModel: CarouselCellViewModel) {
        if viewModel.imageURLs.count > 1 {
            for url in viewModel.imageURLs {
                imageView.downloadImage(from: url)
            }
        } else {
            imageView.downloadImage(from: viewModel.imageURL)
        }
    }
}
