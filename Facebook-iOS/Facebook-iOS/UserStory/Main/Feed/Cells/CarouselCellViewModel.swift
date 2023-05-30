//
//  CarouselViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 29/05/23.
//

import Foundation

struct CarouselCellViewModel: Hashable {
    let id: UUID
    let imageURL: URL
    
    init(imageURL: URL) {
        self.id = UUID()
        self.imageURL = imageURL
    }
}
