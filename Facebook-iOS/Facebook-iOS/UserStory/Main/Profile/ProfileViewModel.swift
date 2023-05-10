//
//  ProfileViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func didFetchProfileData()
}

protocol ProfileViewModelProtocol: AnyObject {
    var delegate: ProfileViewModelDelegate? { get set }
    func fetchProfileData()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    weak var delegate: ProfileViewModelDelegate?
    private let profileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    
    func fetchProfileData() {
        profileNetworkService.fetchProfileData { result in
            switch result {
            case .success(let data):
                print("ID: \(data.id)")
                print("Name: \(data.firstName)")
                print("Last: \(data.lastName)")
                print(data.ageRange?.min)
                print(data.email)
                print(data.birthday)
                print("Picture: \(data.picture.data.url)")
                print("user data fetching successful")
            case .failure(let error):
                print("Error fetching user profile data: \(error)")
            }
        }
    }
}
