//
//  Day.swift
//  
//
//  Created by Chad Parker on 5/7/21.
//

import Foundation

public struct Day {

    public let date: Date
    public let posts: [Post]

    public init(date: Date, posts: [Post]) {
        self.date = date
        self.posts = posts
    }
}

extension Day: Equatable {

    public static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date
    }
}

extension Day: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}
