//
//  CreatePostViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//

import Foundation

protocol CreatePostViewModelDelegate: AnyObject {
    func didDisplayProfileData(viewModel: CreatePostDataViewModel)
}

protocol CreatePostViewModelProtocol: AnyObject {
    var delegate: CreatePostViewModelDelegate? { get set }
    func fetchProfileData()
}

final class CreatePostViewModel {
    var delegate: CreatePostViewModelDelegate?
    private let profileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    
    var userProfileData: UserProfileData?
}

extension CreatePostViewModel: CreatePostViewModelProtocol {
    
    func fetchProfileData() {
        profileNetworkService.fetchProfileData { [weak self] result in
            switch result {
            case .success(let userData):
                print("user data fetching successful")
                self?.userProfileData = userData
                guard let profileImageURL = self?.userProfileData?.picture.data.url else { return }
                guard let safeProfileImageData = URL(string: profileImageURL) else { return }
                guard let firstName = self?.userProfileData?.firstName else { return }
                guard let lastName = self?.userProfileData?.lastName else { return }
                let fullName = firstName + " " + lastName
                
                let displayData = CreatePostDataViewModel(profileImageURL: safeProfileImageData, username: fullName)
                self?.delegate?.didDisplayProfileData(viewModel: displayData)
            case .failure(let error):
                print("Error fetching user profile data: \(NetworkServiceErrors.decodingFailed)")
                print(error.localizedDescription)
            }
        }
    }
    
}
