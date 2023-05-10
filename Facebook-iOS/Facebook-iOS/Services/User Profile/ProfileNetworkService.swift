//
//  ProfileNetworkService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 10/05/23.
//

import FacebookCore
import Foundation

class ProfileNetworkService: ProfileNetworkServiceProtocol {
    
    let connection = GraphRequestConnection()
    let params = ["fields": "id, first_name, picture, last_name"]
    
    func fetchProfileData(completion: @escaping (Result<UserProfileData, Error>) -> Void) {
        connection.add(GraphRequest(graphPath: "me",
                                    parameters: params,
                                    httpMethod: .get)) { connection, result, error in
            if let error = error {
                completion(.failure(error))
                print("Getting user data error: \(error.localizedDescription)")
                return
            } else if let userData = result as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: userData)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    print(jsonData)
                    let userProfileData = try decoder.decode(UserProfileData.self, from: jsonData)
                    print("object created")
                    completion(.success(userProfileData))
                } catch {
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
                completion(.failure(error))
            }
        }
        connection.start()
    }
}
