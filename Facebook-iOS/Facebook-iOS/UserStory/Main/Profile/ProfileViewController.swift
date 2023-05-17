//
//  ProfileViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

protocol ProfileCoordinatorFinishDelegate: AnyObject {
    func didFinishProfileCoordinator()
}

final class ProfileViewController: UIViewController {
    
    weak var profileFinishDelegate: ProfileCoordinatorFinishDelegate?
    
    private let profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    private let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
        profileViewModel.delegate = self
        profileViewModel.fetchProfileData()
        profileView.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
    }
    
}

extension ProfileViewController: ProfileViewModelDelegate {
    
    func didFetchProfileData(profileData: UserProfileData) {
        DispatchQueue.main.async { [weak self] in
            // Update UI elements with the profile data
            guard let safeProfileImageData = URL(string: profileData.picture.data.url) else {
                return
            }
            self?.profileView.customProfileImage.downloadImage(from: safeProfileImageData)
            self?.profileView.backgroundImageView.downloadImage(from: safeProfileImageData)
            self?.profileView.usernameLabel.text = profileData.firstName + " " + profileData.lastName
            
            let bioText = profileData.about + " " + profileData.email
            let highlightText = NSMutableAttributedString(string: bioText)
            let linkRange = (bioText as NSString).range(of: profileData.email)
            highlightText.addAttribute(.link, value: profileData.email, range: linkRange)
            highlightText.addAttribute(.foregroundColor, value: UIColor.blue, range: linkRange)
            self?.profileView.userBioText.delegate = self
            self?.profileView.userBioText.attributedText = highlightText
        }
    }
    
}

extension ProfileViewController: ProfileLogoutDelegate {
    func didLogoutTapped() {
        self.profileViewModel.startLogout { result in
            switch result {
            case .success:
                print("Profile view finishes, going to Sign In")
                self.profileFinishDelegate?.didFinishProfileCoordinator()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension ProfileViewController: UITextViewDelegate {
    
}
