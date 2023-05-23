//
//  FeedView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 23/05/23.
//

import UIKit

class FeedView: UIView {
    
    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unable to initialize View")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
    }

}

extension FeedView: UITableViewDelegate {
    
}

extension FeedView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier,
                                                       for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        let feedDatum = FeedDatum(message: "Sample message", createdTime: Date(), attachments: nil, id: "123")
        let feedData = FeedData(data: [feedDatum], paging: Paging(previous: "", next: ""))
        let pictureData = PictureData(url: "https://example.com/profile_picture.jpg")
        let picture = Picture(data: pictureData)
        let userProfileData = UserProfileData(id: "123", firstName: "John", picture: picture, lastName: "Doe", ageRange: nil)

        let feedCellViewModel = FeedTableViewCellViewModel(post: feedData, profile: userProfileData)
        cell.configure(feedViewModel: feedCellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
