//
//  ProfileNetworkService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 10/05/23.
//

import FacebookCore
import Foundation

class ProfileNetworkService: ProfileNetworkServiceProtocol {
    
    private let connection: GraphRequestConnection = GraphRequestConnection()
    private let requestParameters: [String: Any] = ["fields": "id, first_name, picture, last_name"]
    
    func fetchProfileData(completion: @escaping (Result<UserProfileData, ProfileNetworkServiceErrors>) -> Void) {
        connection.add(GraphRequest(graphPath: "me",
                                    parameters: requestParameters,
                                    httpMethod: .get)) { connection, result, error in
            if let error = error {
                completion(.failure(ProfileNetworkServiceErrors.invalidResponse))
                print("Getting user data error: \(error.localizedDescription)")
                return
            } else if let userData = result {
                print("JSON: \(userData). END")
                self.parseJSON(json: userData) { result in
                    switch result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(ProfileNetworkServiceErrors.decodingFailed))
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        connection.start()
    }
    
    private func parseJSON(json: Any, completion: @escaping (Result<UserProfileData, ProfileNetworkServiceErrors>) -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            let userProfileData = try decoder.decode(UserProfileData.self, from: jsonData)
            completion(.success(userProfileData))
        } catch {
            completion(.failure(ProfileNetworkServiceErrors.serverError))
        }
    }
    
}
