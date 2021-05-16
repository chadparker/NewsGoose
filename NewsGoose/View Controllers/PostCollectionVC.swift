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

    var pointsThreshold: Int = 0 {
        didSet {
            observePosts()
        }
    }

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
            elementKind: .postCollectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true // this is slow with a long list,
                                                // and my design has visual flaws when scrolling quickly. rework later.
        section.boundarySupplementaryItems = [sectionHeader]

        return UICollectionViewCompositionalLayout(section: section)
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

        let headerRegistration = UICollectionView.SupplementaryRegistration<DayHeaderReusableView>(elementKind: .postCollectionHeader) { headerView, string, indexPath in
            guard let post = self.dataSource.itemIdentifier(for: indexPath) else { return }
            headerView.date = post.date
        }

        dataSource.supplementaryViewProvider = { view, kind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
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
        postsCancellable = Database.shared.observePostsOrderedByDate(
            pointsThreshold: pointsThreshold,
            limit: 300,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] posts in
                guard let self = self else { return }
                let snapshot = self.dataSnapshot(for: posts)
                self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
            }
        )
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }
        presentSafariVC(for: post, showing: .post)
    }
}

extension PostCollectionVC: PostCellDelegate {

    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments)
    }
}
