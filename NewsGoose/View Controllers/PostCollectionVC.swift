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

    private var selectedPost: Post?
    private var dataSource: UICollectionViewDiffableDataSource<Day, Post>!
    private var postsCancellable: DatabaseCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.showsVerticalScrollIndicator = false
        self.clearsSelectionOnViewWillAppear = false
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        observePosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let selectedPost = selectedPost else { return }
        NotificationCenter.default.post(name: .backToAppFromSafariVC, object: nil, userInfo: ["selectedPost": selectedPost])
        self.selectedPost = nil
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: .postCollectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true // this is slow with a long list,
                                                // and my design has visual flaws when scrolling quickly. rework later.
        section.boundarySupplementaryItems = [sectionHeader]

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<PostCell, Post> { cell, indexPath, post in
            cell.post = post
            cell.delegate = self
        }

        dataSource = UICollectionViewDiffableDataSource<Day, Post>(collectionView: collectionView) {
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

    private func dataSnapshot(for posts: [Post]) -> NSDiffableDataSourceSnapshot<Day, Post> {
        let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
            .map(Day.init)
            .sorted { $0.date > $1.date }
        var snapshot = NSDiffableDataSourceSnapshot<Day, Post>()
        for day in postsGroupedByDay {
            snapshot.appendSections([day])
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
        guard let post = dataSource.itemIdentifier(for: indexPath) else { preconditionFailure("no post") }
        selectedPost = post
        UserDefaults.markPostAsRead(post.id)
        presentSafariVC(for: post, showing: .post)
    }
}

extension PostCollectionVC: PostCellDelegate {

    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments) {}
    }
}
