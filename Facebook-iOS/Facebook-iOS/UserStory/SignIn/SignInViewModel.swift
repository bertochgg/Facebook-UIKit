//
//  SignInViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 26/04/23.
//

import Foundation

protocol AuthenticationDelegate: AnyObject {
    func didSignIn()
}

protocol SignInViewModelProtocol {
    var delegate: AuthenticationDelegate? { get set }
    func fetchSignInData()
}

class SignInViewModel {
    
    weak var delegate: AuthenticationDelegate?
    
}

extension SignInViewModel: SignInViewModelProtocol {
    
    func fetchSignInData() {
        // Notitfy View that data has been accepted
        delegate?.didSignIn() // Async?
    }
    
}
