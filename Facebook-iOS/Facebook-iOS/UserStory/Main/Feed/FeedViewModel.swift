//  FeedViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//
import Foundation

protocol FeedViewModelDelegate: AnyObject {
    func didFetchFeedData(feedData: [FeedTableViewCellViewModel])
    func didFailFetchingFeedData(with error: NetworkServiceErrors)
    func didReachEndOfData()
}

protocol FeedViewModelProtocol: AnyObject {
    var delegate: FeedViewModelDelegate? { get set }
    func fetchFeedData()
    func fetchNewFeedData()
}

final class FeedViewModel: FeedViewModelProtocol {
    
    weak var delegate: FeedViewModelDelegate?
    private let feedNetworkService: FeedNetworkServiceProtocol = FeedNetworkService()
    private let userProfileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    private var viewModels: [FeedTableViewCellViewModel] = []
    private var currentPageURL: String?
    private var isFetching = false
    private var hasMoreDataToLoad = true
    
    func fetchFeedData() {
        guard !isFetching else { return }
        isFetching = true
        
        let graphPath = "me/feed"
        let requestParameters: [String: Any] = ["fields": "message, created_time, attachments", "limit": "10"]
        
        self.fetchCellData(path: graphPath, parameters: requestParameters)
    }
    
    func fetchNewFeedData() {
        guard let currentPageURL = currentPageURL, !isFetching, hasMoreDataToLoad else {
            self.delegate?.didReachEndOfData()
            return
        }
        isFetching = true
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
        // Here you take out the + from paramters
        let cleanedFields = fields.split(separator: "+").joined()
        let unwrappedParameters = [
            "access_token": accessToken, "until": until,
            "fields": cleanedFields, "__paging_token": pagingToken, "limit": "10"
        ]
        
        self.fetchCellData(path: currentPagePath, parameters: unwrappedParameters)
    }
    
    private func fetchCellData(path: String, parameters: [String: Any]) {
        let group = DispatchGroup()
        var newFeedData: FeedData?
        var userProfileData: UserProfileData?
        var feedNetworkError: NetworkServiceErrors?
        var profileNetworkError: NetworkServiceErrors?
        
        group.enter()
        feedNetworkService.fetchFeedData(graphPath: path, parameters: parameters as [String: Any]) { result in
            switch result {
            case .success(let data):
                if !data.data.isEmpty && data.paging != nil {
                    self.currentPageURL = data.paging?.next
                    newFeedData = data
                } else {
                    self.hasMoreDataToLoad = false
                }
            case .failure(let error):
                feedNetworkError = error
            }
            group.leave()
        }
        
        group.enter()
        userProfileNetworkService.fetchProfileData { result in
            switch result {
            case .success(let data):
                userProfileData = data
            case .failure(let error):
                profileNetworkError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = feedNetworkError ?? profileNetworkError {
                self.delegate?.didFailFetchingFeedData(with: error)
                self.isFetching = false
                return
            }
            
            guard let newFeedData = newFeedData, let userProfileData = userProfileData else {
                self.isFetching = false
                return
            }
            
            let newViewModels = newFeedData.data.map { feedDatum -> FeedTableViewCellViewModel in
                var imageURLs: [URL] = []
                if let attachments = feedDatum.attachments,
                   let subattachments = attachments.data.first?.subattachments {
                    imageURLs = subattachments.data.compactMap { $0.media.image?.src }
                }
                
                return FeedTableViewCellViewModel(
                    id: UUID(),
                    profileImageURL: userProfileData.picture.data.url,
                    username: "\(userProfileData.firstName) \(userProfileData.lastName)",
                    creationTime: feedDatum.createdTime.dateFormatting(),
                    message: feedDatum.message,
                    imageURLs: imageURLs,
                    imageURL: feedDatum.attachments?.data.first?.media?.image?.src
                )
            }
            
            self.viewModels.append(contentsOf: newViewModels)
            self.delegate?.didFetchFeedData(feedData: self.viewModels)
            self.isFetching = false
        }
    }
}
