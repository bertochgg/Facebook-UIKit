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
    
    init(feedDatum: FeedDatum, userData: UserProfileData) {
        self.id = UUID() // Generate a unique identifier, otherwise it will crash x.X
        let username = userData.firstName + " " + userData.lastName
        self.profileImageURL = userData.picture.data.url
        self.username = username
        self.creationTime = feedDatum.createdTime.dateFormatting()
        self.message = feedDatum.message
        self.imageURLs = [feedDatum.attachments?.data.first?.subattachments?.data.first?.media.image?.src]
        self.imageURL = feedDatum.attachments?.data.first?.media?.image?.src
    }
}
