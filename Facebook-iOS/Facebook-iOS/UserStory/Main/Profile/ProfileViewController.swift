//
//  ProfileViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 04/05/23.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    weak var coordinator: (any ProfileCoordinatorProtocol)?
    private var profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        profileViewModel.delegate = self
    }

}

extension ProfileViewController: ProfileViewModelDelegate {
    
    func didFetchProfileData() {
        
    }
    
}
