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
//    private let fbAuthService: FacebookAuthServiceProtocol = FacebookAuthService()
//
//    func signInWithFacebook(from viewController: UIViewController, completion: @escaping (Result<AccessToken, Error>) -> Void) {
//        fbAuthService.signIn(from: viewController, completion: completion)
//    }

}

extension SignInViewModel: SignInViewModelProtocol {
    
    func fetchSignInData() {
        // Notitfy View that data has been accepted
        delegate?.didSignIn() // Async?
    }
    
}
