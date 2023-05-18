//
//  ProfileNetworkServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 10/05/23.
//
import FBSDKCoreKit
import Foundation

protocol ProfileNetworkServiceProtocol {
    func fetchProfileData(completion: @escaping (Result<UserProfileData, NetworkServiceErrors>) -> Void)
}
