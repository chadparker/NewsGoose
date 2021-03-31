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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.delegate = self
            self.searchVC = searchVC
        }
    }
    
    @IBAction func showSearch(_ sender: UIButton) {
        searchContainer.isHidden = false
        searchVC.activate()
    }
}

extension MainVC: SearchVCDelegate {
    
    func cancelButtonTapped() {
        searchContainer.isHidden = true
    }
}
