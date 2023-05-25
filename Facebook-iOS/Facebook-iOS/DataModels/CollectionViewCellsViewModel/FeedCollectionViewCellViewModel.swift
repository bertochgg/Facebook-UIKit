//
//  FeedCollectionViewCellViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 24/05/23.
//

import UIKit

struct FeedCollectionViewCellViewModel {
    private let post: FeedData
    
    init(post: FeedData) {
        self.post = post
    }
    
    var image: URL? {
        return post.data.first?.attachments?.data.first?.media?.image?.src
    }
    
}
