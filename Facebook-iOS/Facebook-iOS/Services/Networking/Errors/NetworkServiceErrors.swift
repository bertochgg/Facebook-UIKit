//
//  NetworkServiceErrors.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

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
