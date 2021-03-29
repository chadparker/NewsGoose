//
//  PostTableVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import UIKit

class PostTableVC: UITableViewController {

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)

        cell.textLabel?.text = "\(indexPath.row + 1)"

        return cell
    }
}
