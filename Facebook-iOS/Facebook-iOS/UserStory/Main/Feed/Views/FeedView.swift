//
//  FeedView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 23/05/23.
//

import UIKit

class FeedView: UIView {
    
    private let tableView = UITableView()
    
    let post =

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
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FeedView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier,
                                                       for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        // create a view model and pass it to the cell. Inside this viewModel should be the 'post' entity with
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
