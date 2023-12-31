//
//  ProfileViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

private enum Constants {
    static let defaultProfileImage = "https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg"
}

final class ProfileViewController: UIViewController {
    
    weak var coordinator: (any ProfileCoordinatorProtocol)?
    private let profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    private let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
        profileViewModel.delegate = self
        profileView.delegate = self
        profileView.postDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        profileViewModel.fetchProfileData()
    }
    
}

extension ProfileViewController: ProfileViewModelDelegate {
    
    func didFetchProfileData(profileData: UserProfileData) {
        DispatchQueue.main.async { [weak self] in
            // Update UI elements with the profile data
            guard let safeProfileImageData = URL(string: profileData.picture.data.url ?? Constants.defaultProfileImage) else {
                return
            }
            self?.profileView.profileImageURL = safeProfileImageData
            self?.profileView.backgroundImageURL = safeProfileImageData
            self?.profileView.username = profileData.firstName + " " + profileData.lastName
            self?.profileView.userBio = (text: profileData.about, email: profileData.email)
        }
    }
    
}

extension ProfileViewController: ProfileLogoutDelegate {
    func didLogoutTapped() {
        self.profileViewModel.startLogout { result in
            switch result {
            case .success:
                print("Profile view finishes, going to Sign In")
                self.coordinator?.finish()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension ProfileViewController: CreatePostDelegate {
    func didTapAddPost() {
        self.coordinator?.showCreatePostViewController()
    }
}
