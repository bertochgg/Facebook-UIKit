//
//  CarouselViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 29/05/23.
//

import Foundation

struct CarouselCellViewModel: Hashable {
    let id: UUID
    var imageURLs: [URL]
    let imageURL: URL
    
    init(imageURLs: [URL], imageURL: URL) {
        self.id = UUID()
        self.imageURLs = imageURLs
        self.imageURL = imageURL
    }
}
