//
//  ProfileNetworkServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 10/05/23.
//
import FBSDKCoreKit
import Foundation

enum NetworkServiceErrors: Error {
    case clientError
    case decodingFailed
    case serverError
    case noConnection
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .clientError:
            return "The request could not be completed due to an error on the client side."
        case .decodingFailed:
            return "The decode failed. Please check that all model's properties match JSON's properties."
        case .serverError:
            return "Something wrong happened when trying to communicate with server."
        case .unknownError:
            return "Unknown error, please contact you support manager."
        case .noConnection:
            return "No connection to any network detected, please verify wi-fi connection."
        }
    }
}

protocol ProfileNetworkServiceProtocol {
    func fetchProfileData(completion: @escaping (Result<UserProfileData, NetworkServiceErrors>) -> Void)
}
