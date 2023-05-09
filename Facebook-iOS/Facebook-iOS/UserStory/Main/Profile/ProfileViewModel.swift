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
    
    func fetchProfileData() {
        
    }
}
