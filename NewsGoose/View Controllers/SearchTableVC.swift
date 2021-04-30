//
//  SearchTableVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/31/21.
//

import UIKit
import CoreData
import SafariServices
import NGCore

class SearchTableVC: UITableViewController {

    var postDBController: PostDBController!
    private var searchQuery: String?

    private var postsGroupedByDay: [(day: Date, posts: [Post])] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "SearchTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func search(query: String?) {
        searchQuery = query // needed?
        if let query = query {
            postDBController.fetchPostsMatching(query: query) { postsGroupedByDay in
                self.postsGroupedByDay = postsGroupedByDay
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! PostCell

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

extension SearchTableVC: PostCellDelegate {
    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments)
    }
}
