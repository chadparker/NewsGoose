//
//  Database.swift
//  
//
//  Created by Chad Parker on 4/30/21.
//

import Foundation
import GRDB

/// Lets the application access the database.
public final class Database {

    // MARK: - Static

    public static let shared = makeShared()

    public static var directory: URL! {
        didSet {
            try! FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }

    public static func copyDBFromBundle() {
        let bundledDB = Bundle.main.resourceURL!.appendingPathComponent("db.sqlite")
        let workingDB = directory.appendingPathComponent("db.sqlite")
        #warning("need to hash the DB files to compare if app update has a new version?")
        if !FileManager.default.fileExists(atPath: workingDB.path) {
            try! FileManager.default.copyItem(at: bundledDB, to: workingDB)
        }
    }

    private static func makeShared() -> Database {
        do {
            let dbURL = directory.appendingPathComponent("db.sqlite")
            let dbPool = try DatabasePool(path: dbURL.path)
            return try Database(dbPool)
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }

    // MARK: - Instance

    /// Provides access to the database.
    /// Application can use a `DatabasePool`, and tests can use a fast in-memory `DatabaseQueue`.
    private let dbWriter: DatabaseWriter

    /// Creates a `Database`, and make sure the database schema is ready.
    init(_ dbWriter: DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }

    /// The DatabaseMigrator that defines the database schema.
    private var migrator: DatabaseMigrator {

        var migrator = DatabaseMigrator()

        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif

        migrator.registerMigration("createProject") { db in
            try db.create(table: "post") { t in
                t.column("id", .text).primaryKey()

                t.column("link_text", .text).notNull()
                t.column("link", .text).notNull()
                t.column("submitter", .text).notNull()

                t.column("type", .text)
                t.column("source", .text)
                t.column("dead", .boolean).notNull()

                t.column("points", .integer).indexed()
                t.column("comments", .integer)

                t.column("date", .datetime).notNull().indexed()
                t.column("day", .datetime).notNull()

                t.column("js_id", .integer).notNull()
            }
        }

        return migrator
    }
}


// MARK: - Database: Writes

extension Database {

    func savePost(_ post: inout Post) throws {
        try dbWriter.write { db in
            try post.save(db)
        }
    }

    func savePosts(_ posts: [Post]) throws {
        try dbWriter.write { db in
            for var post in posts {
                post.day = post.startOfDay() // temporary
                try post.save(db)
            }
        }
    }

    func deleteAllPosts() throws {
        try dbWriter.write { db in
            _ = try Post.deleteAll(db)
        }
    }
}


// MARK: - Database: Reads

extension Database {

    func mostRecentJSID() throws -> Int {
        try dbWriter.read { db in
            return try Post
                .order(Post.Columns.date.desc)
                .filter(Post.Columns.js_id > 0)
                .fetchOne(db)!
                .js_id!
        }
    }

    public func recentPosts(pointsThreshold: Int, limit: Int) throws -> [Post] {
        try dbWriter.read { db in
            return try Post
                .order(Post.Columns.date.desc)
                .filter(Post.Columns.points >= pointsThreshold)
                .limit(limit)
                .fetchAll(db)
        }
    }

    public func postsMatching(query: String) throws -> [Post] {
        try dbWriter.read { db in
            return try Post
                .filter(Post.Columns.link_text.like("%\(query)%"))
                .order(Post.Columns.date.desc)
                .limit(3000)
                .fetchAll(db)
        }
    }
}

// MARK: - Database: Observations

extension Database {

    /// Tracks changes in players ordered by name
    public func observePostsOrderedByDate(limit: Int, onError: @escaping (Error) -> Void, onChange: @escaping ([Post]) -> Void) -> DatabaseCancellable {
        return ValueObservation
            .tracking(Post.all().orderedByDate().limit(limit).fetchAll)
            .start(in: dbWriter, onError: onError, onChange: onChange)
    }
}
