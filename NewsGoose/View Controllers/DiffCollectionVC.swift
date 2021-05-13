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

    var postManager = PostManager()

    var dataSource: UICollectionViewDiffableDataSource<Int, Post>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(UINib(nibName: "DiffCell", bundle: nil), forCellWithReuseIdentifier: DiffCell.reuseIdentifier)
        configureDataSource()
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)

        return layout
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Post>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Post) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiffCell.reuseIdentifier, for: indexPath) as! DiffCell
            cell.text = "\(item.link_text)"
            return cell
        }

        // initial data
        dataSource.apply(dataSnapshot(), animatingDifferences: false)
    }

    func dataSnapshot() -> NSDiffableDataSourceSnapshot<Int, Post> {

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
