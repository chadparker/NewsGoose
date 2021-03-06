//
//  Extensions.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/5/21.
//

import UIKit
import SafariServices
import NGCore

extension UserDefaults {

    private enum Keys {
        static let pointsThreshold = "pointsThreshold"
        static let postsBeenRead = "postsBeenRead"
    }

    static var pointsThreshold: Int {
        get {
            if standard.value(forKey: Keys.pointsThreshold) == nil {
                return pointsThresholdDefault
            }
            return standard.integer(forKey: Keys.pointsThreshold)
        }
        set {
            standard.set(newValue, forKey: Keys.pointsThreshold)
        }
    }

    static func markPostAsRead(_ postId: String) {
        if standard.object(forKey: Keys.postsBeenRead) == nil {
            initializePostsBeenRead()
        }
        guard var dict = standard.object(forKey: Keys.postsBeenRead) as? [String: Bool] else { preconditionFailure("no dict") }
        dict[postId] = true
        standard.set(dict, forKey: Keys.postsBeenRead)
    }

    static func postBeenRead(_ postId: String) -> Bool {
        if standard.object(forKey: Keys.postsBeenRead) == nil {
            initializePostsBeenRead()
        }
        guard let dict = standard.object(forKey: Keys.postsBeenRead) as? [String: Bool] else { preconditionFailure("no dict")}
        return dict[postId] != nil
    }

    static private func initializePostsBeenRead() {
        standard.set([String:Bool](), forKey: Keys.postsBeenRead)
    }
}

extension String {
    static var postCollectionHeader = "post-collection-header"
}

extension Notification.Name {
    static let backToAppFromSafariVC = Notification.Name(rawValue: "backToAppFromSafariVC")
}

enum LaunchPostLinkType {
    case post
    case comments
}

extension UIViewController {

    static var presentSafariCompletionHandler: () -> Void = {}
    
    func presentSafariVC(for post: Post, showing linkType: LaunchPostLinkType, completion: @escaping () -> Void) {
        Self.presentSafariCompletionHandler = completion
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
        present(vc, animated: true) {
            Self.presentSafariCompletionHandler()
        }
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
