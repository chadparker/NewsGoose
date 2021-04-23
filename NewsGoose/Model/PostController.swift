//
//  PostController.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import Foundation
import GRDB

class PostController {
    
    let backgroundQueue = DispatchQueue(label: "DatabaseBackgroundQueue", qos: .userInitiated)
    
    init() {
        
    }
    
    func fetchRecentPosts(pointsThreshold: Int, completion: @escaping ([Post]) -> Void) {
        backgroundQueue.async {
            do {
                try dbQueue.read { db in
                    let posts = try Post
                        .order(Column("date").desc)
                        .filter(Column("points") >= pointsThreshold)
                        .limit(3000)
                        .fetchAll(db)
                    DispatchQueue.main.async {
                        completion(posts)
                    }
                }
            } catch {
                fatalError("read error")
            }
        }
    }
}
