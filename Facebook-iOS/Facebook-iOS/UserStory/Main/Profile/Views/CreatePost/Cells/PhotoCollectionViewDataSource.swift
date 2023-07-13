//
//  PhotoCollectionViewDataSource.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 13/07/23.
//

import UIKit

class CreatePostDataSource: NSObject {
    weak var delegate: PhotoCollectionViewCellDelegate?
    private let collectionView: UICollectionView
    private var viewModels: [PhotoCollectionViewCellViewModel]
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoCollectionViewCellViewModel>?

    init(collectionView: UICollectionView, viewModels: [PhotoCollectionViewCellViewModel], delegate: PhotoCollectionViewCellDelegate?) {
        self.delegate = delegate
        self.collectionView = collectionView
        self.viewModels = viewModels
        super.init()
        configureDataSource()
        applySnapshot()
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, PhotoCollectionViewCellViewModel>(collectionView: collectionView) {[weak self] collectionView, indexPath, viewModel in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self?.delegate
            cell.configure(with: viewModel)
            return cell
        }
    }

    private func applySnapshot() {
        guard let dataSource = dataSource else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoCollectionViewCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModels)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func update(with viewModels: [PhotoCollectionViewCellViewModel]) {
        self.viewModels = viewModels
        applySnapshot()
    }
}
