//
//  DiffCollectionVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/10/21.
//

import UIKit

class DiffCollectionVC: UICollectionViewController {

    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil

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
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Int) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiffCell.reuseIdentifier, for: indexPath) as! DiffCell
            cell.text = "\(item)"
            return cell
        }

        // initial data
        dataSource.apply(dataSnapshot(), animatingDifferences: false)
    }

    func dataSnapshot() -> NSDiffableDataSourceSnapshot<Int, Int> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems([0, 1, 2, 3], toSection: 0)
        snapshot.appendSections([1])
        snapshot.appendItems([4, 5], toSection: 1)
        return snapshot
    }
}
