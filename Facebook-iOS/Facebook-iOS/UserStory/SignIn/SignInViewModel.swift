//
//  SignInViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 26/04/23.
//

import Foundation

protocol SignInDelegate: AnyObject {
    func didSignIn()
}

protocol SignInViewModelProtocol {
    var delegate: SignInDelegate? { get set }
    func fetchSignInData()
}

class SignInViewModel {
    
    weak var delegate: SignInDelegate?
    
}

extension SignInViewModel: SignInViewModelProtocol {
    
    func fetchSignInData() {
        // Notitfy View that data has been accepted
        delegate?.didSignIn() // Async?
    }
    
}
