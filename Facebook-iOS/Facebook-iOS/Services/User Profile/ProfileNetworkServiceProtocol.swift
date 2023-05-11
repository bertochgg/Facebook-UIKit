//
//  ProfileNetworkServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 10/05/23.
//
import FBSDKCoreKit
import Foundation

enum NetworkServiceErrors: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case serverError
    case noConnection
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL for request."
        case .invalidResponse:
            return "Invalid response from server."
        case .decodingFailed:
            return "The decode failed."
        case .serverError:
            return "Something wrong happened when trying to communicate with server."
        case .unknown:
            return "Unknown error, please contact you support manager."
        case .noConnection:
            return "No connection to any network detected, please verify wi-fi connection."
        }
    }
}

protocol ProfileNetworkServiceProtocol {
    func fetchProfileData(completion: @escaping (Result<UserProfileData, NetworkServiceErrors>) -> Void)
}
