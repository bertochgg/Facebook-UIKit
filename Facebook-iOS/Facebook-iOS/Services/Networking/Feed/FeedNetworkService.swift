//
//  FeedService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import FacebookCore
import Foundation

class FeedNetworkService: FeedNetworkServiceProtocol {
    
    private let requestParameters: [String: Any] = ["fields": "message, created_time, attachments"]
    
    func fetchFeedData(graphPath: String, parameters: [String: Any], completion: @escaping (Result<FeedData, NetworkServiceErrors>) -> Void) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: graphPath, parameters: parameters, httpMethod: .get)) { connection, response, error in
            print("Path: \(graphPath)")
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
                guard let jsonProfileData = response as? [String: Any] else {
                    completion(.failure(NetworkServiceErrors.decodingFailed))
                    return
                }
                self.parseJSON(json: jsonProfileData, completion: completion)
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

    private func parseJSON(json: Any, completion: @escaping (Result<FeedData, NetworkServiceErrors>) -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            decoder.dateDecodingStrategy = .iso8601
            let feedData = try decoder.decode(FeedData.self, from: jsonData)
            completion(.success(feedData))
        } catch let error {
            completion(.failure(NetworkServiceErrors.decodingFailed))
            print(error.localizedDescription)
        }
    }
}
