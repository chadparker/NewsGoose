//
//  Extensions.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/5/21.
//

import UIKit
import SafariServices
import NGCore

extension String {
    static var postCollectionHeader: String {
        "post-collection-header"
    }
}

enum LaunchPostLinkType {
    case post
    case comments
}

extension UIViewController {
    
    func presentSafariVC(for post: Post, showing linkType: LaunchPostLinkType) {
        switch linkType {
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

extension DateFormatter {

    static let dateWithoutYear: DateFormatter = {
        let formatter = DateFormatter()
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)!
        formatter.dateFormat = "EE, MMM d"
        return formatter
    }()

    static let dateWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d, yyyy"
        return formatter
    }()
}
