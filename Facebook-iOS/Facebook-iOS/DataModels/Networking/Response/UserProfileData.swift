//
//  UserModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/05/23.
//

import Foundation

// MARK: - User Profile Data
struct UserProfileData: Codable {
    let id: String
    let firstName: String
    let picture: Picture
    let lastName: String
    let birthday: String = "19/09/1997"
    let email: String = "humberto@gmail.com"
    let ageRange: AgeRange?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case picture
        case lastName = "last_name"
        case birthday
        case email
        case ageRange = "age_range"
    }
}

// MARK: - Age  Range
struct AgeRange: Codable {
    let min: Int = 21

    enum CodingKeys: String, CodingKey {
        case min
    }
}

// MARK: - Picture
struct Picture: Codable {
    let data: PictureData
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Picture Data
struct PictureData: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
