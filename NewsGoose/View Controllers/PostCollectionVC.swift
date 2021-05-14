//
//  PostCollectionVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/10/21.
//

import UIKit
import NGCore
import GRDB

class PostCollectionVC: UICollectionViewController {

    private static let sectionHeaderElementKind = "section-header-element-kind"

    private var dataSource: UICollectionViewDiffableDataSource<Date, Post>!
    private var postsCancellable: DatabaseCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.showsVerticalScrollIndicator = false
        self.clearsSelectionOnViewWillAppear = false
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        observePosts()
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44)),
            elementKind: PostCollectionVC.sectionHeaderElementKind,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true // this is slow with a long list,
                                                // and my design has visual flaws when scrolling quickly. rework later.
        section.boundarySupplementaryItems = [sectionHeader]

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<DiffCell, Post> { cell, indexPath, post in
            cell.post = post
            cell.delegate = self
        }

        dataSource = UICollectionViewDiffableDataSource<Date, Post>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, post: Post) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: post)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<DateHeaderReusableView>(elementKind: PostCollectionVC.sectionHeaderElementKind) { headerView, string, indexPath in
            guard let post = self.dataSource.itemIdentifier(for: indexPath) else { return }
            headerView.date = post.date
        }

        dataSource.supplementaryViewProvider = { view, kind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        // initial data
        let posts = try! Database.shared.recentPosts(pointsThreshold: 500, limit: 300)
        let snapshot = dataSnapshot(for: posts)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func dataSnapshot(for posts: [Post]) -> NSDiffableDataSourceSnapshot<Date, Post> {
        let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
            .map { (date: $0.key, posts: $0.value) }
            .sorted { $0.date > $1.date }
        var snapshot = NSDiffableDataSourceSnapshot<Date, Post>()
        for day in postsGroupedByDay {
            snapshot.appendSections([day.date])
            snapshot.appendItems(day.posts)
        }
        return snapshot
    }

    private func observePosts() {
        postsCancellable = Database.shared.observePostsOrderedByDate(limit: 300,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] posts in
                self?.updateDataSource(with: posts)
            }
        )
    }

    private func updateDataSource(with posts: [Post]) {
        let snapshot = dataSnapshot(for: posts)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension PostCollectionVC: PostCellDelegate {

    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments)
    }
}
