//
//  PostManager.swift
//  
//
//  Created by Chad Parker on 4/30/21.
//

import Foundation

public class PostManager {

    let postDBController = PostDBController()

    public init() {}

    public func recentPostsGroupedByDay(pointsThreshold: Int, completion: @escaping ([(day: Date, posts: [Post])]) -> Void) {

        postDBController.fetchRecentPosts(pointsThreshold: pointsThreshold) { posts in
            let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
                .map { (day: $0.key, posts: $0.value) }
                .sorted { $0.day > $1.day }
            completion(postsGroupedByDay)
        }
    }

    public func postsMatching(query: String, completion: @escaping ([(day: Date, posts: [Post])]) -> Void) {

        postDBController.fetchPostsMatching(query: query) { posts in
            let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
                .map { (day: $0.key, posts: $0.value) }
                .sorted { $0.day > $1.day }
            completion(postsGroupedByDay)
        }
    }
}
