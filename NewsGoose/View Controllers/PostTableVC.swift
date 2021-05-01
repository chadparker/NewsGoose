//
//  PostTableVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import UIKit
import CoreData
import SafariServices
import NGCore

/// Displays a list of Posts sorted and grouped by date.
class PostTableVC: UITableViewController {
    
    var postManager: PostManager!
    var pointThreshold: Int = 0 {
        didSet {
            performDBFetch()
        }
    }

    private var postsGroupedByDay: [(day: Date, posts: [Post])] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        //performDBFetch()
        postManager.loadLatestPosts { result in
            switch result {
            case .success(_):
                self.performDBFetch()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func performDBFetch() {
        postManager.recentPostsGroupedByDay(pointsThreshold: pointThreshold) { postsGroupedByDay in
            self.postsGroupedByDay = postsGroupedByDay
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = postsGroupedByDay[indexPath.section]
        let post = section.posts[indexPath.row]
        presentSafariVC(for: post, showing: .post)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return postsGroupedByDay.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = postsGroupedByDay[section]
        return section.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath) as! PostCell

        let section = postsGroupedByDay[indexPath.section]
        let post = section.posts[indexPath.row]
        cell.post = post
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = postsGroupedByDay[section]
        let date = section.day
        return DateFormatter.fullDate.string(from: date)
    }
}

extension PostTableVC: PostCellDelegate {
    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments)
    }
}
