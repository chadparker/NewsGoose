//
//  SearchVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/30/21.
//

import UIKit

protocol SearchVCDelegate {
    func cancelButtonTapped()
}

class SearchVC: UIViewController {
    
    var delegate: SearchVCDelegate!
    var searchTableVC: SearchTableVC!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var searchTableContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
    }
    
    func activate() {
        searchBar.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchTableVC = segue.destination as? SearchTableVC {
            self.searchTableVC = searchTableVC
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText == "" {
//            searchTableVC.search(query: nil)
//        } else {
//            searchTableVC.search(query: searchText)
//        }
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.searchTextField.text! == "" {
            searchTableVC.search(query: nil)
        } else {
            searchTableVC.search(query: searchBar.searchTextField.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate.cancelButtonTapped()
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchTableVC.search(query: nil)
    }
}
