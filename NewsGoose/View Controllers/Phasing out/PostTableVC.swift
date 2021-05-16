//
//  PostTableVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import UIKit
import NGCore
import GRDB

/// Displays a list of Posts sorted and grouped by date.
class PostTableVC: UITableViewController {
    
    var postManager: PostManager!
    var pointThreshold: Int = 0 {
        didSet {
//            performDBFetch()
        }
    }

    private var dataSource: UITableViewDiffableDataSource<Day, Post>!
    private var postsCancellable: DatabaseCancellable?
    //var posts: [Post] = []

    private var postsGroupedByDay: [Day] = [] {
        didSet {
//            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50

//        configureDataSource()
//        observePosts()
//        
//        postManager.loadLatestPosts { result in
////            switch result {
////            case .success(_):
////                self.performDBFetch()
////            case .failure(let error):
////                print(error)
////            }
//        }
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Day, Post>(tableView: tableView) { (tableView, indexPath, post) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath)// as! PostCell

            //let section = self.postsGroupedByDay[indexPath.section]
            //let post = section.posts[indexPath.row]
//            cell.post = post
//            cell.delegate = self

            return cell
        }
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
    }

    private func observePosts() {
        postsCancellable = Database.shared.observePostsOrderedByDate(
            pointsThreshold: pointThreshold,
            limit: 3000,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] posts in
                self?.updateDataSource(from: posts)
            }
        )
    }

    private func updateDataSource(from posts: [Post]) {
        let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
            .map { Day(date: $0, posts: $1) }
            .sorted { $0.date > $1.date }
        var snapshot = NSDiffableDataSourceSnapshot<Day, Post>()
        snapshot.deleteAllItems()
        for day in postsGroupedByDay {
            snapshot.appendSections([day])
            snapshot.appendItems(posts)
        }
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
//    private func performDBFetch() {
//        postsGroupedByDay = postManager.recentPostsGroupedByDay(pointsThreshold: pointThreshold)
//    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = dataSource.itemIdentifier(for: indexPath) else { return }
        presentSafariVC(for: post, showing: .post)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return postsGroupedByDay.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let section = postsGroupedByDay[section]
//        return section.posts.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath) as! PostCell
//
//        let section = postsGroupedByDay[indexPath.section]
//        let post = section.posts[indexPath.row]
//        cell.post = post
//        cell.delegate = self
//
//        return cell
//    }

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let section = postsGroupedByDay[section]
//        let date = section.date
//        return DateFormatter.fullDate.string(from: date)
//    }

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DaySectionHeaderView.reuseIdentifier) as! DaySectionHeaderView
//
//
//        return header
//    }
}

extension PostTableVC: PostCellDelegate {
    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments)
    }
}
