//
//  FacebookAuthService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 28/04/23.
//
import FacebookLogin
import Foundation

class FacebookAuthService/*: FacebookAuthServiceProtocol */{
//    private let loginManager = LoginManager()
//
//    func signIn(from viewController: UIViewController, completion: @escaping (Result<AccessToken, Error>) -> Void) {
//
//        loginManager.logIn(permissions: [.publicProfile, .email], viewController: viewController) { loginResult, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let token = loginResult.token else {
//                completion(.failure(AuthServiceError.invalidAccessToken))
//                return
//            }
//
//            completion(.success(token))
//        }
//    }
    
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
