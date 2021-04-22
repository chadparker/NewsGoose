//
//  DatabaseManager.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/22/21.
//

import Foundation
import GRDB

var dbQueue: DatabaseQueue!

class DatabaseManager {
    
    static func setup() throws {
        let path = "\(Bundle.main.resourcePath!)/db.sqlite"
        dbQueue = try DatabaseQueue(path: path)
        try migrator.migrate(dbQueue)
    }
    
    static var migrator: DatabaseMigrator {
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
                
                t.column("points", .integer)
                t.column("comments", .integer)
                
                t.column("date", .datetime).notNull()
                t.column("time", .datetime)
            }
        }
        
        return migrator
    }
}
