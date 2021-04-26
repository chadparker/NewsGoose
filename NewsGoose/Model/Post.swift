//
//  Post.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/22/21.
//

import Foundation
import GRDB

struct Post {

    let id: String

    let link_text: String
    let link: String
    let submitter: String

    let type: String?
    let source: String?
    let dead: Bool

    let points: Int?
    let comments: Int?

    let date: Date
    let time: Date?
    var day: Date?
}

extension Post: Codable, FetchableRecord, MutablePersistableRecord {
    
}
