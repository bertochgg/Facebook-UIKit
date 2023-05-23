//
//  FeedTableViewCellData.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import UIKit

struct FeedTableViewCellViewModel {
    private let post: FeedData
    private let profile: UserProfileData
    
    init(post: FeedData, profile: UserProfileData) {
        self.post = post
        self.profile = profile
    }
    
    var profileImageView: URL? {
        return URL(string: profile.picture.data.url)
    }
    
    var usernameLabel: String {
        let username = profile.firstName + " " + profile.lastName
        return username
    }
    
    var creationTimeLabel: Date? {
        return post.data.first?.createdTime
    }
    
    var privacyImage: UIImage? {
        return UIImage(named: "Privacy Icon")
    }
    
    var messageTextView: String? {
        return post.data.first?.message
    }
}
