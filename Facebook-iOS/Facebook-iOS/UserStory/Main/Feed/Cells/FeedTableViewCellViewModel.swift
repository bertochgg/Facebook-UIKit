//
//  FeedTableViewCellViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 28/05/23.
//

import Foundation

struct FeedTableViewCellViewModel {
    private let post: FeedData
    private let profileData: UserProfileData
    
    init(post: FeedData, profileData: UserProfileData) {
        self.post = post
        self.profileData = profileData
    }
    
    var profileImage: String {
        return profileData.picture.data.url
    }
    
    var username: String {
        let username = profileData.firstName + " " + profileData.lastName
        return username
    }
    
    var creationTime: String {
        
    }
}
