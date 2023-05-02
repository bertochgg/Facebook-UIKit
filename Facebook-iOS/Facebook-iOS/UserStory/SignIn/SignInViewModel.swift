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
    func fetchSignInData(from viewController: UIViewController, completion: @escaping (Result<AccessToken, Error>) -> Void)
}

class SignInViewModel {
    
    weak var delegate: SignInViewModelDelegate?
    private let fbAuthService: FacebookAuthServiceProtocol = FacebookAuthService()

}

extension SignInViewModel: SignInViewModelProtocol {
    
    func fetchSignInData(from viewController: UIViewController, completion: @escaping (Result<AccessToken, Error>) -> Void) {
        fbAuthService.signIn(from: viewController) { result in
            switch result {
            case .success(let token):
                // Notitfy View that data has been accepted
                self.delegate?.didSignIn() // Async?
            case .failure(let error):
                // Notitfy View that data has been accepted
                self.delegate?.didSignIn() // Async?
            }
        }
        
    }
    
}
