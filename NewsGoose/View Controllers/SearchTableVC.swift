//
//  SearchTableVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/31/21.
//

import UIKit
import CoreData
import SafariServices

class SearchTableVC: UITableViewController {

    var postController: PostController!
    
    private var searchQuery: String?
    private var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
//    lazy private var fetchedResultsController: NSFetchedResultsController<Post> = {
//        let moc = CoreDataStack.shared.mainContext
//        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dayFormatted", cacheName: nil)
//        frc.delegate = self
//        try! frc.performFetch()
//        return frc
//    }()
//    
//    private var fetchRequest: NSFetchRequest<Post> {
//        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
//        fetchRequest.predicate = predicate
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//        fetchRequest.fetchLimit = 3000
//        return fetchRequest
//    }
//    
//    private var predicate: NSPredicate {
//        var predicates: [NSPredicate] = []
//        if let query = searchQuery {
//            predicates.append(NSPredicate(format: "link_text CONTAINS[c] %@", query))
//        } else {
//            predicates.append(NSPredicate(format: "points < 0")) // temporary fix to start with zero results
//        }
//        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "SearchTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func search(query: String?) {
        searchQuery = query // needed?
        if let query = query {
            postController.fetchPostsMatching(query: query) { posts in
                self.posts = posts
            }
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        presentSafariVC(for: post, showing: .post)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController.sections?.count ?? 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! PostCell

        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
//
//        return sectionInfo.name
//    }
}

extension SearchTableVC: PostCellDelegate {
    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments)
    }
}
