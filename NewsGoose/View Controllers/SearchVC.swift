//
//  SearchVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/30/21.
//

import UIKit

protocol SearchVCDelegate {
    //func search(query: String?)
    func cancelButtonTapped()
}

class SearchVC: UIViewController {
    
    var delegate: SearchVCDelegate!

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
    }
    
    func activate() {
        searchBar.becomeFirstResponder()
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            //delegate.search(query: nil)
        } else {
            //delegate.search(query: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.searchTextField.text! == "" {
            //delegate.search(query: nil)
        } else {
            //delegate.search(query: searchBar.searchTextField.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate.cancelButtonTapped()
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
}
