//
//  FeedTableViewCellViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 28/05/23.
//

import Foundation

struct FeedTableViewCellViewModel: Hashable {
    let profileImageURL: String
    let username: String
    let creationTime: String
    let message: String?
    let imageURLs: URL?
    
    init(feedDatum: FeedDatum, userData: UserProfileData) {
        let username = userData.firstName + " " + userData.lastName
        self.profileImageURL = userData.picture.data.url
        self.username = username
        self.creationTime = feedDatum.createdTime.dateFormatting()
        self.message = feedDatum.message
        self.imageURLs = feedDatum.attachments?.data.first?.media?.image?.src
    }
    
}
