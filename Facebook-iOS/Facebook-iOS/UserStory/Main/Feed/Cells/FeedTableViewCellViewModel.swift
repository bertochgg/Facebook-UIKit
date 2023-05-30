//
//  FeedTableViewCellViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 28/05/23.
//

import Foundation

struct FeedTableViewCellViewModel: Hashable {
    let id: UUID
    let profileImageURL: String
    let username: String
    let creationTime: String
    let message: String?
    let imageURLs: [URL?]
    let imageURL: URL?
}
