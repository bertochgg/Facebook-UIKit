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
    func resetLoadStateWhenHasNoMoreData()
}

final class FeedViewModel: FeedViewModelProtocol {
    
    weak var delegate: FeedViewModelDelegate?
    private let feedNetworkService: FeedNetworkServiceProtocol = FeedNetworkService()
    private let userProfileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    private var userProfileData: UserProfileData?
    private var viewModels: [FeedTableViewCellViewModel] = []
    private var currentPageURL: String?
    private var isFetching = false
    private var hasMoreDataToLoad = true
    
    func fetchFeedData() {
        self.viewModels.removeAll()
        fetchCellData(fetchMethod: feedNetworkService.fetchInitialFeedData)
    }
    
    func fetchNewFeedData() {
        guard let currentPageURL = currentPageURL, hasMoreDataToLoad else {
            self.delegate?.didReachEndOfData()
            // self.hasMoreDataToLoad = true
            return
        }
        
        fetchCellData(fetchMethod: { completion in
            self.feedNetworkService.fetchNewFeedData(currentPageURL: currentPageURL, completion: completion)
        })
    }
    
    func resetLoadStateWhenHasNoMoreData() {
        self.hasMoreDataToLoad = true
    }
    
    private func extractImageURLs(from subattachments: Subattachments?) -> [URL] {
        guard let subattachmentsData = subattachments?.data else { return [] }
        return subattachmentsData.compactMap { $0.media.image?.src }
    }
    
    private func fetchCellData(fetchMethod: @escaping (@escaping (Result<FeedData, NetworkServiceErrors>) -> Void) -> Void) {
        guard !isFetching else { return }
        isFetching = true
        
        let group = DispatchGroup()
        var newFeedData: FeedData?
        var networkError: NetworkServiceErrors?
        
        if userProfileData == nil {
            group.enter()
            userProfileNetworkService.fetchProfileData { result in
                switch result {
                case .success(let data):
                    self.userProfileData = data
                case .failure(let error):
                    self.delegate?.didFailFetchingFeedData(with: error)
                    self.isFetching = false
                }
                group.leave()
            }
        }
        
        group.enter()
        fetchMethod { result in
            switch result {
            case .success(let data):
                if !data.data.isEmpty && data.paging != nil {
                    self.currentPageURL = data.paging?.next
                    newFeedData = data
                } else {
                    print("No data at end")
                    self.hasMoreDataToLoad = false
                    self.delegate?.didReachEndOfData()
                }
            case .failure(let error):
                networkError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = networkError {
                self.delegate?.didFailFetchingFeedData(with: error)
                self.isFetching = false
                return
            }
            
            guard let newFeedData = newFeedData,
                  let userProfileData = self.userProfileData else {
                self.isFetching = false
                return
            }
            
            let newViewModels: [FeedTableViewCellViewModel] = newFeedData.data.map { feedDatum in
                let imageURLs = self.extractImageURLs(from: feedDatum.attachments?.data.first?.subattachments)
                
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
