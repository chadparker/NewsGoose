//
//  PostTableVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import UIKit
import CoreData
import SafariServices

class PostTableVC: UITableViewController {
    
    var pointThreshold: Int = 0
    
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
//        NSPredicate(format: "points >= %i", pointThreshold)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostTableCell")
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 50
//    }
    
    func filter(points: Int) {
        pointThreshold = points
//        performFetch()
    }
    
//    private func performFetch() {
//        fetchedResultsController.fetchRequest.predicate = predicate
//        try! fetchedResultsController.performFetch()
//        tableView.reloadData()
//    }
//    
//    // MARK: - Table view delegate
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = fetchedResultsController.object(at: indexPath)
//        presentSafariVC(for: post, showing: .post)
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController.sections?.count ?? 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath) as! PostCell
//
//        let post = fetchedResultsController.object(at: indexPath)
//        cell.post = post
//        cell.delegate = self
//
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
//        
//        return sectionInfo.name
//    }
}

extension PostTableVC: PostCellDelegate {
    func showComments(for post: Post) {
        presentSafariVC(for: post, showing: .comments)
    }
}
