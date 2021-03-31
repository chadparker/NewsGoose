//
//  MainVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var searchContainer: UIView!
    var searchVC: SearchVC!
    var postTableVC: PostTableVC!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.delegate = self
            self.searchVC = searchVC
        } else if let postTableVC = segue.destination as? PostTableVC {
            self.postTableVC = postTableVC
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        let buttonText = sender.titleLabel!.text!
        let digitsString = buttonText.replacingOccurrences(of: "\\D",
                                                           with: "",
                                                           options: .regularExpression,
                                                           range: buttonText.startIndex..<buttonText.endIndex)
        postTableVC.filter(points: Int(digitsString) ?? 0)
    }
    
    @IBAction func showSearch(_ sender: UIButton) {
        searchContainer.isHidden = false
        searchVC.activate()
    }
}

extension MainVC: SearchVCDelegate {

//    func search(query: String?) {
//        postTableVC.search(query: query)
//    }

    func cancelButtonTapped() {
        searchContainer.isHidden = true
        //postTableVC.search(query: nil)
    }
}
