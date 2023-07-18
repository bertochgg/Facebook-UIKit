//
//  PhotoCollectionViewDataSource.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 13/07/23.
//

import UIKit

class CreatePostDataSource {
    weak var delegate: PhotoCollectionViewCellDelegate?
    private let collectionView: UICollectionView
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoCollectionViewCellViewModel>?

    init(collectionView: UICollectionView, delegate: PhotoCollectionViewCellDelegate?) {
        self.collectionView = collectionView
        self.delegate = delegate
        configureDataSource()
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, PhotoCollectionViewCellViewModel>(collectionView: collectionView) { [weak self] collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self?.delegate
            cell.configure(with: viewModel)
            return cell
        }
    }

    private func applySnapshot(with viewModels: [PhotoCollectionViewCellViewModel]) {
        guard let dataSource = dataSource else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoCollectionViewCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModels)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func update(with viewModels: [PhotoCollectionViewCellViewModel]) {
        applySnapshot(with: viewModels)
    }
}
