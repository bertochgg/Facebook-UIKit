//
//  PhotoCollectionViewCellViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/07/23.
//

import UIKit

struct PhotoCollectionViewCellViewModel: Hashable {
    let id: UUID
    let image: UIImage?
    let isPlaceholder: Bool
    
    init(id: UUID? = nil, image: UIImage?) {
        if let id = id {
            self.id = id
        } else {
            self.id = UUID()
        }
        
        if image == ImagesNames.placeholderImage {
            self.isPlaceholder = true
            self.image = ImagesNames.placeholderImage
        } else {
            self.isPlaceholder = false
            self.image = image
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(image)
    }
    
    static func == (_ lhs: PhotoCollectionViewCellViewModel, _ rhs: PhotoCollectionViewCellViewModel) -> Bool {
        lhs.id == rhs.id && lhs.image == rhs.image
    }
}
