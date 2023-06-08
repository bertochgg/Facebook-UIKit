//
//  FeedService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import FacebookCore
import Foundation

class FeedNetworkService: FeedNetworkServiceProtocol, GenericNetworkService {
    typealias DataModel = FeedData
    
    func fetchInitialFeedData(completion: @escaping (Result<DataModel, NetworkServiceErrors>) -> Void) {
        let graphPath = "me/feed"
        let parameters: [String: Any] = ["fields": "message, created_time, attachments", "limit": "10"]
        fetchData(graphPath: graphPath, parameters: parameters, completion: completion)
    }
    
    func fetchNewFeedData(currentPageURL: String, completion: @escaping (Result<DataModel, NetworkServiceErrors>) -> Void) {
        // Get path and parameters from currentPageURL
        let urlComponents = URLComponents(string: currentPageURL)
        let currentPagePath = urlComponents?.path ?? ""
        var parameters: [String: Any] = [:]
        for queryItem in urlComponents?.queryItems ?? [] {
            if let value = queryItem.value {
                parameters[queryItem.name] = value
            }
        }
        
        // Here, you unwrap the values
        guard let accessToken = parameters["access_token"] as? String,
              let until = parameters["until"] as? String,
              let fields = parameters["fields"] as? String,
              let pagingToken = parameters["__paging_token"] as? String else {
            print("Failed to unwrap parameters")
            return
        }
        // Here you take out the + from fields
        let cleanedFields = fields.split(separator: "+").joined()
        let unwrappedParameters = [
            "access_token": accessToken, "until": until,
            "fields": cleanedFields, "__paging_token": pagingToken, "limit": "10"
        ]
        
        fetchData(graphPath: currentPagePath, parameters: unwrappedParameters, completion: completion)
    }
    
    private func fetchData(graphPath: String, parameters: [String: Any], completion: @escaping (Result<DataModel, NetworkServiceErrors>) -> Void) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: graphPath, parameters: parameters, httpMethod: .get)) { connection, response, error in
            print("Path: \(graphPath)")
            print("Parameters: \(parameters)")
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
    
}
