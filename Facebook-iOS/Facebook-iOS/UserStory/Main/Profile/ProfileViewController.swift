//
//  ProfileViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    weak var coordinator: (any ProfileCoordinatorProtocol)?
    private let profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    private let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        profileViewModel.delegate = self
        profileViewModel.fetchProfileData()
    }

}

extension ProfileViewController: ProfileViewModelDelegate {
    
    func didFetchProfileData() {
        
    }
    
}
