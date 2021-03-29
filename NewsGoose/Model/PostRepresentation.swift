//
//  PostRepresentation.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import Foundation

struct PostRepresentation: Decodable {

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
}
