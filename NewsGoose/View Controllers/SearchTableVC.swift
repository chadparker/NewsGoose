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

    private var searchQuery: String?
    
    lazy private var fetchedResultsController: NSFetchedResultsController<Post> = {
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dayFormatted", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    private var fetchRequest: NSFetchRequest<Post> {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 3000
        return fetchRequest
    }
    
    private var predicate: NSPredicate {
        var predicates: [NSPredicate] = []
        if let query = searchQuery {
            predicates.append(NSPredicate(format: "link_text CONTAINS[c] %@", query))
        } else {
            predicates.append(NSPredicate(format: "points < 0")) // temporary fix to start with zero results
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "SearchTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func search(query: String?) {
        searchQuery = query
        performFetch()
    }
    
    private func performFetch() {
        fetchedResultsController.fetchRequest.predicate = predicate
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    private func presentSafariVC(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("urlString is not a URL")
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = fetchedResultsController.object(at: indexPath)
        guard let urlString = post.link else {
            fatalError()
        }
        presentSafariVC(urlString)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! PostCell

        let post = fetchedResultsController.object(at: indexPath)
        cell.post = post
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        
        return sectionInfo.name
    }
}

extension SearchTableVC: PostCellDelegate {
    func showComments(id: String) {
        presentSafariVC("https://news.ycombinator.com/item?id=\(id)")
    }
}

// MARK: - FRC Delegate

extension SearchTableVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
            let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
