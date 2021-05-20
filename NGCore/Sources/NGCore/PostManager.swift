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

    public func loadLatestPosts(completion: ((Result<Int, PostNetworkError>) -> Void)? = nil) {
        postNetworkFetcher.fetchLatest { result in
            switch result {
            case .success(let posts):
                try! Database.shared.savePosts(posts)
                completion?(.success(posts.count))
            case .failure(let error):
                completion?(.failure(error))
            }
        }

        let newestJSID = try! Database.shared.mostRecentJSID()
        let todayJSID = Date().jsInt
        let jsIDsToFetch = ((newestJSID - 3)...todayJSID).reversed()


        DispatchQueue.global().async {

            let dispatchGroup = DispatchGroup()

            for jsID in jsIDsToFetch {
                dispatchGroup.enter()
                print("fetching \(jsID)")
                self.postNetworkFetcher.fetchDay(jsID) { result in
                    switch result {
                    case .success(let posts):
                        try! Database.shared.savePosts(posts)
                        dispatchGroup.leave()
                    case .failure(let error):
                        switch error {
                        case .notFound:
                            dispatchGroup.leave()
                        default:
                            fatalError()
                        }
                    }
                }
                dispatchGroup.wait()
            }
        }
    }

//    public func recentPostsGroupedByDay(pointsThreshold: Int, limit: Int) -> [(date: Date, posts: [Post])] {
//        let posts = try! Database.shared.recentPosts(pointsThreshold: pointsThreshold, limit: limit)
//        let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
//            .map { (date: $0.key, posts: $0.value) }
//            .sorted { $0.date > $1.date }
//        return postsGroupedByDay
//
//    }

//    public func postsGroupedByDayMatching(query: String) -> [(day: Date, posts: [Post])] {
//        let posts = try! Database.shared.postsMatching(query: query)
//        let postsGroupedByDay = Dictionary(grouping: posts) { $0.day! }
//            .map { (day: $0.key, posts: $0.value) }
//            .sorted { $0.day > $1.day }
//        return postsGroupedByDay
//    }
}
