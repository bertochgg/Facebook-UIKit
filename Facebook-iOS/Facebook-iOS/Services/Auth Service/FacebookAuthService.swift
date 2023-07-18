//
//  FacebookAuthService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 28/04/23.
//
import FacebookLogin
import Foundation

class FacebookAuthService: FacebookAuthServiceProtocol {
    private let loginManager = LoginManager()
    
    func signIn(completion: @escaping (Result<AccessToken, AuthServiceError>) -> Void) {
        
        self.loginManager.logIn(permissions: [.publicProfile, .email]) { loginResult in
            switch loginResult {
            case .success( _, _, let accessToken):
                // Handle successful login
                print("Logged in with Facebook!")
                
                if let token = accessToken {
                    completion(.success(token))
                }
                
            case .failed(let error):
                // Handle login failure
                print("Facebook login failed: \(error.localizedDescription)")
                completion(.failure(AuthServiceError.invalidAccessToken))
                
            case .cancelled:
                // Handle cancelled login
                 completion(.failure(AuthServiceError.cancelLogin))
                
            }
            
        }
    }
    
}

enum AuthServiceError: Error {
    case invalidAccessToken
    case cancelLogin
    
    var localizedDescription: String {
        switch self {
        case .invalidAccessToken:
            return "Invalid access token received from Facebook SDK."
        case .cancelLogin:
            return "Facebook login cancelled"
        }
    }
}
