//
//  ProfileViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func didFetchProfileData(profileData: UserProfileData)
}

protocol ProfileViewModelProtocol: AnyObject {
    var delegate: ProfileViewModelDelegate? { get set }
    func fetchProfileData()
    func startLogout(completion: @escaping (Result<Void, Error>) -> Void)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    weak var delegate: ProfileViewModelDelegate?
    private let profileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    private let keychainService: KeychainServiceProtocol = KeychainService(serviceName: KeychainKeys.keychainServiceName)
    
    var userProfileData: UserProfileData?
    
    func fetchProfileData() {
        profileNetworkService.fetchProfileData { result in
            switch result {
            case .success(let userData):
                print("ID: \(userData.id)")
                print("Name: \(userData.firstName)")
                print("Last: \(userData.lastName)")
                print(userData.ageRange?.min)
                print(userData.email)
                print(userData.birthday)
                print("Picture: \(userData.picture.data.url)")
                print("user data fetching successful")
                
                self.userProfileData = userData
                self.delegate?.didFetchProfileData(profileData: userData)
            case .failure(let error):
                print("Error fetching user profile data: \(NetworkServiceErrors.decodingFailed)")
                print(error.localizedDescription)
            }
        }
    }
    
    func startLogout(completion: @escaping (Result<Void, Error>) -> Void) {
        keychainService.deleteCache(forKey: KeychainKeys.userAccessTokenKey, completion: completion)
    }
}
