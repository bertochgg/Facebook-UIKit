//
//  ImageSliderCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 22/05/23.
//

import UIKit

class ImageSliderCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
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
        imageView.downloadImage(from: viewModel.imageURL)
    }
}
