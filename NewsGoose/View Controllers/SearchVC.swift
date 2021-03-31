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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate.cancelButtonTapped()
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
}
