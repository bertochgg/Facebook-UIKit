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
        feedNetworkService.fetchFeedData { [weak self] result in
            switch result {
            case .success(let feedData):
                self?.userProfileNetworkService.fetchProfileData { [weak self] result in
                    switch result {
                    case .success(let userProfileData):
                        let viewModels = feedData.data.map { feedDatum -> FeedTableViewCellViewModel in
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
                        self?.delegate?.didFetchFeedData(feedData: viewModels)
                    case .failure(let error):
                        print("Error fetching user profile data: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error fetching feed data: \(error.localizedDescription)")
            }
        }
    }
}
