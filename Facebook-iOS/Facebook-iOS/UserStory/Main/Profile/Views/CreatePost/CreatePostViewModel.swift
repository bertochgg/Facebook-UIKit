//
//  CreatePostViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//

import Foundation

protocol CreatePostViewModelProtocol: AnyObject {
    var delegate: ProfileViewModelDelegate? { get set }
    func fetchProfileData()
}

final class CreatePostViewModel {
    var delegate: ProfileViewModelDelegate?
    private let profileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    
    var userProfileData: UserProfileData?
}

extension CreatePostViewModel: CreatePostViewModelProtocol {
    
    func fetchProfileData() {
        profileNetworkService.fetchProfileData { result in
            switch result {
            case .success(let userData):
                print("user data fetching successful")
                self.userProfileData = userData
                self.delegate?.didFetchProfileData(profileData: userData)
            case .failure(let error):
                print("Error fetching user profile data: \(NetworkServiceErrors.decodingFailed)")
                print(error.localizedDescription)
            }
        }
    }
}

