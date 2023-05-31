//
//  FeedViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 08/05/23.
//

import Foundation

protocol FeedViewModelDelegate: AnyObject {
    func didFetchFeedData(feedData: [FeedTableViewCellViewModel])
}

protocol FeedViewModelProtocol: AnyObject {
    var delegate: FeedViewModelDelegate? { get set }
    func fetchFeedData()
}

final class FeedViewModel: FeedViewModelProtocol {
    
    weak var delegate: FeedViewModelDelegate?
    private let feedNetworkService: FeedNetworkServiceProtocol = FeedNetworkService()
    private let userProfileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    
    func fetchFeedData() {
        let group = DispatchGroup()
        var feedData: FeedData?
        var userProfileData: UserProfileData?
        var viewModels: [FeedTableViewCellViewModel] = []
        
        group.enter()
        feedNetworkService.fetchFeedData { result in
            switch result {
            case .success(let data):
                feedData = data
            case .failure(let error):
                print("Error fetching feed data: \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.enter()
        userProfileNetworkService.fetchProfileData { result in
            switch result {
            case .success(let data):
                userProfileData = data
            case .failure(let error):
                print("Error fetching user profile data: \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            guard let feedData = feedData, let userProfileData = userProfileData else { return }
            
            viewModels = feedData.data.map { feedDatum -> FeedTableViewCellViewModel in
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
            
            self.delegate?.didFetchFeedData(feedData: viewModels)
        }
    }

}
