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
    
    func fetchProfileData(completion: @escaping (Result<UserProfileData, NetworkServiceErrors>) -> Void) {
        connection.add(GraphRequest(graphPath: "me",
                                    parameters: requestParameters,
                                    httpMethod: .get)) { connection, response, error in
            
            guard error == nil else {
                completion(.failure(NetworkServiceErrors.noConnection))
                return
            }
            
            guard let httpResponse = connection?.urlResponse else {
                completion(.failure(NetworkServiceErrors.unknownError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                // Success
                guard let userData = response as? [String: Any] else {
                    completion(.failure(NetworkServiceErrors.decodingFailed))
                    return
                }
                self.handleSuccess(jsonData: userData, completion: completion)
            case 400...499:
                // Client error
                completion(.failure(NetworkServiceErrors.clientError))
            case 500...599:
                // Server error
                completion(.failure(NetworkServiceErrors.serverError))
            default:
                // Unknown error
                completion(.failure(NetworkServiceErrors.unknownError))
            }
            
        }
        connection.start()
    }
    
    private func parseJSON(json: Any, completion: @escaping (Result<UserProfileData, NetworkServiceErrors>) -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            let userProfileData = try decoder.decode(UserProfileData.self, from: jsonData)
            completion(.success(userProfileData))
        } catch let error {
            completion(.failure(NetworkServiceErrors.decodingFailed))
            print(error.localizedDescription)
        }
    }
    
    private func handleSuccess(jsonData: Any, completion: @escaping (Result<UserProfileData, NetworkServiceErrors>) -> Void) {
        
        self.parseJSON(json: jsonData) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(NetworkServiceErrors.decodingFailed))
                print("Failed parse JSON Error: \(error.localizedDescription)")
            }
        }
    }
    
}
