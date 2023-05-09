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
    func didSignInWithFailure()
    func didCancelSignIn()
}

protocol SignInViewModelProtocol {
    var delegate: SignInViewModelDelegate? { get set }
    func signInWithFacebook()
}

class SignInViewModel {
    
    weak var delegate: SignInViewModelDelegate?
    private let fbAuthService: FacebookAuthServiceProtocol = FacebookAuthService()
    private let keychainService: KeychainServiceProtocol = KeychainService(serviceName: KeychainKeys.keychainServiceName)
    
}

extension SignInViewModel: SignInViewModelProtocol {
    
    func signInWithFacebook() {
        var token: AccessToken?
        
        fbAuthService.signIn { result in
            switch result {
            case .success(let fbToken):
                token = fbToken
                print(result)
            case .failure(let error):
                // Notify View there is an error while signing in
                switch error {
                case .cancelLogin:
                    self.delegate?.didCancelSignIn()
                case .invalidAccessToken:
                    print(error.localizedDescription)
                    self.delegate?.didSignInWithFailure()
                }
            }
        }
        
        if let token = token {
            self.saveToken(token)
            self.delegate?.didSignIn()
        }
        // Something should happen here, maybe we can get data or set flags to see if we are logged in
        
    }
    
    func saveToken(_ token: AccessToken) {
        guard let tokenData = token.tokenString.data(using: .utf8) else {
            return
        }
        
        guard let expirationTokenData = token.expirationDate.description.data(using: .utf8) else {
            return
        }
        
        self.keychainService.save(data: tokenData, forKey: KeychainKeys.userAccessTokenKey) { result in
            switch result {
            case .success:
                print("Access Token Saved")
            case .failure(let error):
                print(error.localizedDescription)
                print("Access Token could not be saved")
            }
        }
        
        self.keychainService.save(data: expirationTokenData, forKey: KeychainKeys.tokenExpirationDateKey) { result in
            switch result {
            case .success:
                print("Token Expiration Date Saved")
                print(expirationTokenData)
            case .failure(let error):
                print(error.localizedDescription)
                print("Token Expiration Date could not be saved")
            }
        }
        
    }
    
}
