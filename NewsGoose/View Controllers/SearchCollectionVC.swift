//
//  SearchCollectionVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/17/21.
//

import UIKit
import NGCore
import GRDB

class SearchCollectionVC: UICollectionViewController {

    private var days: [Day] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(DiffCell.self, forCellWithReuseIdentifier: "SearchDiffCell")
        collectionView.register(DayHeaderReusableView.self, forSupplementaryViewOfKind: .postCollectionHeader, withReuseIdentifier: "SearchDiffHeader")
        collectionView.backgroundColor = .systemBackground
    }

    func search(query: String?) {
        if let query = query {
            let posts = try! Database.shared.postsMatching(query: query, limit: 300)
            let days = Dictionary(grouping: posts) { $0.day! }
                .map(Day.init)
                .sorted { $0.date > $1.date }
            self.days = days
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
        }
    }

    static func createLayout() -> UICollectionViewLayout {
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

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return days.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let day = days[section]
        return day.posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDiffCell", for: indexPath) as! DiffCell
        let day = days[indexPath.section]
        let post = day.posts[indexPath.item]
        cell.post = post
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchDiffHeader", for: indexPath) as! DayHeaderReusableView
        let day = days[indexPath.section]
        header.date = day.date
        return header
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let day = days[indexPath.section]
        let post = day.posts[indexPath.item]
        presentSafariVC(for: post, showing: .post)
    }
}

extension SearchCollectionVC: PostCellDelegate {

    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments)
    }
}
