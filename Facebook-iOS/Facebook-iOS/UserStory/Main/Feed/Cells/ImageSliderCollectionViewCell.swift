//
//  ImageSliderCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 22/05/23.
//

import UIKit

class ImageSliderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "imageSliderCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    public func configure(with viewModel: FeedTableViewCellViewModel) {
        
        let imageURLs = viewModel.imageURLs.compactMap { $0 }
        if imageURLs.count > 1 {
            // Display multiple images in the carousel
            for imageURL in imageURLs {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.downloadImage(from: imageURL)
                imageView.frame = contentView.bounds
                contentView.addSubview(imageView)
            }
        } else if let safeImageURL = viewModel.imageURL {
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.downloadImage(from: safeImageURL)
            imageView.frame = contentView.bounds
            // Add the image view to the carousel
            contentView.addSubview(imageView)
        }
    }

}
