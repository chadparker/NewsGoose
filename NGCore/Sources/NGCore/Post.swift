//
//  Post.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/22/21.
//

import Foundation
import GRDB

public struct Post: Identifiable, Hashable {

    public let id: String

    public let link_text: String
    public let link: String
    public let submitter: String

    public let type: String?
    public let source: String?
    public let dead: Bool

    public let points: Int?
    public let comments: Int?

    public let date: Date
    public var day: Date?
}

// MARK: - Calendar Helper

extension Post {

    func startOfDay() -> Date {
        Post.calendar.startOfDay(for: date)
    }

    private static var calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()
}

// MARK: - Persistence

extension Post: Codable, FetchableRecord, MutablePersistableRecord {

    enum Columns {
        static let date = Column(CodingKeys.date)
        static let points = Column(CodingKeys.points)
    }
}
