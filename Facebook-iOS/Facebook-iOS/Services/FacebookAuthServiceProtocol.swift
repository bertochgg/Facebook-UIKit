//
//  FacebookAuthServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 28/04/23.
//
import FacebookLogin
import UIKit

protocol FacebookAuthServiceProtocol {
    func signIn(completion: @escaping (Result<AccessToken, AuthServiceError>) -> Void)
}
