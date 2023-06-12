//
// GenericNetworkServiceProtocol.swift
// Facebook-iOS
//
// Created by Humberto Garcia on 08/06/23.
//

import Foundation

protocol GenericNetworkServiceProtocol {
  associatedtype DataModel: Decodable
   
  func parseJSON(json: Any, completion: @escaping (Result<DataModel, NetworkServiceErrors>) -> Void)
}

extension GenericNetworkServiceProtocol {
  func parseJSON(json: Any, completion: @escaping (Result<DataModel, NetworkServiceErrors>) -> Void) {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: json)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .useDefaultKeys
      decoder.dateDecodingStrategy = .iso8601
      let decodedData = try decoder.decode(DataModel.self, from: jsonData)
      completion(.success(decodedData))
    } catch let error {
      completion(.failure(NetworkServiceErrors.decodingFailed))
      print(error.localizedDescription)
    }
  }
}
