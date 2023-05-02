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

    func signIn(from viewController: UIViewController, completion: @escaping (Result<AccessToken, Error>) -> Void) {
        
        self.loginManager.logIn(permissions: [.publicProfile, .email], viewController: viewController) { loginResult in
            switch loginResult {
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
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
                print("Facebook login cancelled")
            
            }
            
        }
    }
    
}

enum AuthServiceError: Error {
    case invalidAccessToken

    var localizedDescription: String {
        switch self {
        case .invalidAccessToken:
            return "Invalid access token received from Facebook SDK."
        }
    }
}
