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
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public func configure(with viewModel: FeedViewModel) {
    }
}
