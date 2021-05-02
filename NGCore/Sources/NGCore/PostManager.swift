//
//  PostManager.swift
//  
//
//  Created by Chad Parker on 4/30/21.
//

import Foundation

public final class PostManager {

    let postNetworkFetcher = PostNetworkFetcher()

    public init() {}

    public func loadLatestPosts(completion: @escaping (Result<Int, PostNetworkError>) -> Void) {
        postNetworkFetcher.fetchLatest { result in
            switch result {
            case .success(let posts):
                try! Database.shared.savePosts(posts)
                completion(.success(posts.count))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func recentPostsGroupedByDay(pointsThreshold: Int, completion: @escaping ([(day: Date, posts: [Post])]) -> Void) {
        let posts = try! Database.shared.recentPosts(pointsThreshold: pointsThreshold)
        let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
            .map { (day: $0.key, posts: $0.value) }
            .sorted { $0.day > $1.day }
        completion(postsGroupedByDay)

    }

    public func postsMatching(query: String, completion: @escaping ([(day: Date, posts: [Post])]) -> Void) {
        let posts = try! Database.shared.postsMatching(query: query)
        let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
            .map { (day: $0.key, posts: $0.value) }
            .sorted { $0.day > $1.day }
        completion(postsGroupedByDay)
    }
}
