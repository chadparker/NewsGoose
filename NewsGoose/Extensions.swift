//
//  Extensions.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/5/21.
//

import UIKit
import SafariServices

enum LaunchPostLinkType {
    case post
    case comments
}

extension UIViewController {
    
    func presentSafariVC(for post: Post, showing: LaunchPostLinkType) {
        switch showing {
        case .post:
            if let linkURL = URL(string: post.link) {
                presentURL(linkURL)
            } else {
                presentHNPost(id: post.id)
            }
        case .comments:
            presentHNPost(id: post.id)
        }
        
    }
    
    private func presentURL(_ url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func presentHNPost(id: String) {
        let url = URL(string: "https://news.ycombinator.com/item?id=\(id)")!
        presentURL(url)
    }
}
