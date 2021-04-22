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
        guard let link = post.link,
              let id = post.id else {
            fatalError("link or id is nil")
        }
        
        switch showing {
        case .post:
            if let linkURL = URL(string: link) {
                presentURL(linkURL)
            } else {
                presentHNPost(id: id)
            }
        case .comments:
            presentHNPost(id: id)
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
