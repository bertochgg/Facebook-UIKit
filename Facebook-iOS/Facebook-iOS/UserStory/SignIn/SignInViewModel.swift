//
//  SignInViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 26/04/23.
//
import FacebookLogin
import Foundation

protocol SignInViewModelDelegate: AnyObject {
    func didSignIn()
}

protocol SignInViewModelProtocol {
    var delegate: SignInViewModelDelegate? { get set }
    func fetchSignInData()
}

class SignInViewModel {
    
    weak var delegate: SignInViewModelDelegate?
    private let fbAuthService: FacebookAuthServiceProtocol = FacebookAuthService()
    
}

extension SignInViewModel: SignInViewModelProtocol {
    
    func fetchSignInData() {
        fbAuthService.signIn { result in
            switch result {
            case .success:
                // Notitfy View that data has been accepted
                self.delegate?.didSignIn() // Async?
            case .failure(let error):
                // Notitfy View there is an error while signing in
                print(error.localizedDescription)
            }
        }
        
    }
    
}
