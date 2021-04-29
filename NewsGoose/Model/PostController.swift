//
//  PostController.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import Foundation
import GRDB
import HNKit

class PostController {
    
    let backgroundQueue = DispatchQueue(label: "DatabaseBackgroundQueue", qos: .userInitiated)
    
    init() {
        
    }
    
    func fetchRecentPosts(pointsThreshold: Int, completion: @escaping ([(day: Date, posts: [Post])]) -> Void) {
        backgroundQueue.async {
            do {
                try dbQueue.read { db in
                    let posts = try Post
                        .order(Column("date").desc)
                        .filter(Column("points") >= pointsThreshold)
                        .limit(3000)
                        .fetchAll(db)

                    let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
                        .map { (day: $0.key, posts: $0.value) }
                        .sorted { $0.day > $1.day }

                    DispatchQueue.main.async {
                        completion(postsGroupedByDay)
                    }
                }
            } catch {
                fatalError("read error")
            }
        }
    }
    
    func fetchPostsMatching(query: String, completion: @escaping ([(day: Date, posts: [Post])]) -> Void) {
        backgroundQueue.async {
            do {
                try dbQueue.read { db in
                    let posts = try Post
                        .filter(Column("link_text").like("%\(query)%"))
                        .order(Column("date").desc)
                        .limit(3000)
                        .fetchAll(db)

                    let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
                        .map { (day: $0.key, posts: $0.value) }
                        .sorted { $0.day > $1.day }

                    DispatchQueue.main.async {
                        completion(postsGroupedByDay)
                    }
                }
            } catch {
                fatalError("read error")
            }
        }
    }
}
