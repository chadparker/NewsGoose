//
//  DiffCollectionVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/10/21.
//

import UIKit
import NGCore
import GRDB

class DiffCollectionVC: UICollectionViewController {

    private static let sectionHeaderElementKind = "section-header-element-kind"

    private var postManager = PostManager()

    private var dataSource: UICollectionViewDiffableDataSource<Int, Post>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44)),
            elementKind: DiffCollectionVC.sectionHeaderElementKind,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [sectionHeader]

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30

        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)

        return layout
    }

    private func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<DiffCell, Post> { cell, indexPath, post in
            cell.post = post
        }

        dataSource = UICollectionViewDiffableDataSource<Int, Post>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, post: Post) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: post)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<DateHeaderReusableView>(elementKind: DiffCollectionVC.sectionHeaderElementKind) { headerView, string, indexPath in
            headerView.date = Date()
        }

        dataSource.supplementaryViewProvider = { view, kind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
        }

        // initial data
        dataSource.apply(dataSnapshot(), animatingDifferences: false)
    }

    private func dataSnapshot() -> NSDiffableDataSourceSnapshot<Int, Post> {

        let postsByDay = postManager.recentPostsGroupedByDay(pointsThreshold: 50)
        let posts = postsByDay[2].posts

        var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
        snapshot.appendSections([0])
        snapshot.appendItems([posts[0], posts[1], posts[2], posts[3]], toSection: 0)
        snapshot.appendSections([1])
        snapshot.appendItems([posts[4], posts[5]], toSection: 1)
        return snapshot
    }
}
