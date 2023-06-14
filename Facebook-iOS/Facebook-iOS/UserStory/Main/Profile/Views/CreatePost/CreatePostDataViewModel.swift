//
//  CreatePostDataViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 14/06/23.
//

import Foundation

struct CreatePostDataViewModel {
    let profileImageURL: URL?
    let username: String?
    
    static func transform(from userData: UserProfileData) -> CreatePostDataViewModel {
        let profileImageURLString = userData.picture.data.url ?? ""
        let profileImageURL = URL(string: profileImageURLString)
        let fullName = "\(userData.firstName) \(userData.lastName)"
        return CreatePostDataViewModel(profileImageURL: profileImageURL, username: fullName)
    }
}
