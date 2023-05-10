//
//  UserModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/05/23.
//

import Foundation

// MARK: - Welcome
struct UserProfileData: Codable, Hashable, Equatable {
    
    let id:String
    let firstName: String
    let picture: Picture
    let lastName: String

    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case picture
        case lastName = "last_name"
    }
    
    static func == (lhs: UserProfileData, rhs: UserProfileData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    
}

// MARK: - Picture
struct Picture: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let url: String
}
