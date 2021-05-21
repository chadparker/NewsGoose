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
}
