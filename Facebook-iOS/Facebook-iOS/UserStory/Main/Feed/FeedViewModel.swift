//  FeedViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//
import Foundation

protocol FeedViewModelDelegate: AnyObject {
    func didFetchFeedData(feedData: [FeedTableViewCellViewModel])
    func didFailFetchingFeedData(with error: NetworkServiceErrors)
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
    
    func fetchFeedData() {
        guard !isFetching else { return }
        isFetching = true
        
        let group = DispatchGroup()
        var feedData: FeedData?
        var userProfileData: UserProfileData?
        var feedNetworkError: NetworkServiceErrors?
        var profileNetworkError: NetworkServiceErrors?
        
        let graphPath = "me/feed"
        let requestParameters: [String: Any] = ["fields": "message, created_time, attachments"]
        
        group.enter()
        feedNetworkService.fetchFeedData(graphPath: graphPath, parameters: requestParameters) { result in
            switch result {
            case .success(let data):
                self.currentPageURL = data.paging.next
                feedData = data
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
                return
            }
            
            guard let feedData = feedData, let userProfileData = userProfileData else { return }
            
            let newViewModels = feedData.data.map { feedDatum -> FeedTableViewCellViewModel in
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
    
    func fetchNewFeedData() {
        guard let currentPageURL = currentPageURL, !isFetching else { return }
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
        let pagingToken = parameters["__paging_token"] else {
            print("Failed to unwrap parameters")
            return
        }
        
        let unwrappedParameters = ["access_token": accessToken, "until": until, "fields": fields, "__paging_token": pagingToken]

        let group = DispatchGroup()
        var newFeedData: FeedData?
        var userProfileData: UserProfileData?
        var feedNetworkError: NetworkServiceErrors?
        var profileNetworkError: NetworkServiceErrors?
        
        group.enter()
        feedNetworkService.fetchFeedData(graphPath: currentPagePath, parameters: unwrappedParameters as [String: Any]) { result in
            switch result {
            case .success(let data):
                self.currentPageURL = data.paging.next
                newFeedData = data
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
