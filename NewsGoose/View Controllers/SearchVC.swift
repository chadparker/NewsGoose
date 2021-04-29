//
//  SearchVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/30/21.
//

import UIKit
import HNKit

protocol SearchVCDelegate {
    func hideSearch()
}

class SearchVC: UIViewController {
    
    enum SearchState {
        case hidden
        case emptyView
        case startSearch(String?)
        case showingResults
    }
    
    var delegate: SearchVCDelegate!
    var searchTableVC: SearchTableVC!
    var postController: PostController!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var searchTableContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
    }
    
    func activate() {
        state = .emptyView
    }
    
    private var state: SearchState = .emptyView {
        didSet {
            switch state {
            case .hidden:
                activitySpinner.stopAnimating()
                searchTableContainer.isHidden = true
                                
                searchBar.text = nil
                searchBar.resignFirstResponder()
                searchTableVC.search(query: nil)

                delegate.hideSearch()
                
            case .emptyView:
                activitySpinner.stopAnimating()
                searchTableContainer.isHidden = true
                
                searchBar.text = nil
                searchBar.becomeFirstResponder()
                searchTableVC.search(query: nil)
                
            case .startSearch(let query):
                //activitySpinner.startAnimating()
                searchTableContainer.isHidden = false
                
                searchTableVC.search(query: query)
                
            case .showingResults:
                activitySpinner.stopAnimating()
                searchTableContainer.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchTableVC = segue.destination as? SearchTableVC {
            searchTableVC.postController = postController
            self.searchTableVC = searchTableVC
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            state = .emptyView
        } else {
            state = .startSearch(searchBar.searchTextField.text)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        state = .startSearch(searchBar.searchTextField.text)
//        if searchBar.searchTextField.text! == "" {
//            state = .startSearch(nil)
//        } else {
//            state = .startSearch(searchBar.searchTextField.text!)
//        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        state = .hidden
    }
}
