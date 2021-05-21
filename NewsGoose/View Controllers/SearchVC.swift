//
//  SearchVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/30/21.
//

import UIKit
import NGCore
import SnapKit

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

    private var searchBar = UISearchBar()
    private var searchCollectionVC = SearchCollectionVC(collectionViewLayout: SearchCollectionVC.createLayout())
    //private var activitySpinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    private func setUpViews() {
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.showsCancelButton = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .defaultPrompt)
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaInsets)
            make.height.equalTo(Constants.headerHeight)
        }

        addChild(searchCollectionVC)
        view.addSubview(searchCollectionVC.view)
        searchCollectionVC.didMove(toParent: self)
        searchCollectionVC.view.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaInsets)
        }
    }
    
    func activate() {
        state = .emptyView
    }
    
    private var state: SearchState = .emptyView {
        didSet {
            switch state {
            case .hidden:
                //activitySpinner.stopAnimating()
                searchCollectionVC.view.isHidden = true
                                
                searchBar.text = nil
                searchBar.resignFirstResponder()
                searchCollectionVC.search(query: nil)

                delegate.hideSearch()
                
            case .emptyView:
                //activitySpinner.stopAnimating()
                searchCollectionVC.view.isHidden = true
                
                searchBar.text = nil
                searchBar.becomeFirstResponder()
                searchCollectionVC.search(query: nil)
                
            case .startSearch(let query):
                //activitySpinner.startAnimating()
                searchCollectionVC.view.isHidden = false
                
                searchCollectionVC.search(query: query)
                
            case .showingResults:
                //activitySpinner.stopAnimating()
                searchCollectionVC.view.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchCollectionVC = segue.destination as? SearchCollectionVC {
            self.searchCollectionVC = searchCollectionVC
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
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        state = .hidden
    }
}
