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
    func fetchSignInData()
}

class SignInViewModel {
    
    weak var delegate: SignInViewModelDelegate?
    private let fbAuthService: FacebookAuthServiceProtocol = FacebookAuthService()
    private let keychainService: KeychainServiceProtocol = KeychainService(serviceName: KeychainKeys.keychainServiceName)
    
}

extension SignInViewModel: SignInViewModelProtocol {
    
    func fetchSignInData() {
        let dispatchGroup = DispatchGroup()
        var tokenData: Data?
        var expirationTokenData: Data?
        
        dispatchGroup.enter()
        fbAuthService.signIn { result in
            switch result {
            case .success(let token):
                tokenData = token.tokenString.data(using: .utf8)
                expirationTokenData = token.expirationDate.description.data(using: .utf8)
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
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let tokenData = tokenData {
                self.keychainService.save(data: tokenData, forKey: KeychainKeys.userAccessTokenKey) { result in
                    switch result {
                    case .success:
                        print("Access Token Saved")
                    case .failure(let error):
                        print(error.localizedDescription)
                        print("Access Token could not be saved")
                    }
                }
            }
            
            if let expirationTokenData = expirationTokenData {
                self.keychainService.save(data: expirationTokenData, forKey: KeychainKeys.tokenExpirationDateKey) { result in
                    switch result {
                    case .success:
                        print("Token Expiration Date Saved")
                    case .failure(let error):
                        print(error.localizedDescription)
                        print("Token Expiration Date could not be saved")
                    }
                }
            }
            
            // Notify View that data has been accepted
            self.delegate?.didSignIn() // Async?
            // Something should happen here, maybe we can get data or set flags to see if we are logged in
        }
    }
    
}
