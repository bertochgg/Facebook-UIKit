//
//  FeedView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 23/05/23.
//

import UIKit

protocol FeedViewDelegate: AnyObject {
    func didReachEndOfFeed ()
}

class FeedView: UIView {
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, FeedTableViewCellViewModel>?
    private var isLoadingData = false
    private var hasMoreDataToLoad: Bool = true
    weak var delegate: FeedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unable to initialize View")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func resetLoadingState() {
        self.isLoadingData = false
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
        }
    }
    
    func setHasMoreDataToLoad(_ hasMore: Bool) {
        self.hasMoreDataToLoad = hasMore
    }
    
    private func createLoadingSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.delegate = self
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
    }
    
}

extension FeedView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.height
        
        // If the user has scrolled to the bottom, data is not being fetched, and there is more data to fetch
        if offsetY > contentHeight - tableViewHeight && !isLoadingData && self.hasMoreDataToLoad {
            isLoadingData = true
            self.tableView.tableFooterView = createLoadingSpinner()
            self.delegate?.didReachEndOfFeed()
        }
    }
    
}

extension FeedView {
    func applySnapshot(with viewModels: [FeedTableViewCellViewModel]) {
        guard let dataSource = dataSource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, FeedTableViewCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModels)
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, FeedTableViewCellViewModel>(tableView: tableView) { tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as? FeedTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: viewModel)
            
            return cell
        }
    }
}
