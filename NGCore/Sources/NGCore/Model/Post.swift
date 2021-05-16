//
//  Post.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/22/21.
//

import Foundation
import GRDB

public struct Post: Identifiable {

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

    public var js_id: Int?
}

extension Post: Equatable {

    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Post: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Post: Codable {

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
}

// MARK: - Persistence

extension Post: FetchableRecord, MutablePersistableRecord {

    enum Columns {
        static let link_text = Column(CodingKeys.link_text)
        static let link = Column(CodingKeys.link)
        static let submitter = Column(CodingKeys.submitter)

        static let type = Column(CodingKeys.type)
        static let source = Column(CodingKeys.source)
        static let dead = Column(CodingKeys.dead)

        static let points = Column(CodingKeys.points)
        static let comments = Column(CodingKeys.comments)

        static let date = Column(CodingKeys.date)
        static let day = Column(CodingKeys.day)

        static let js_id = Column(CodingKeys.js_id)
    }
}

// MARK: - Date Helpers

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
