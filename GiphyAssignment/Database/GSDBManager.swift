//
//  GSDBManager.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 27/11/20.
//

import Foundation
import GRDB

// The shared database pool
public var sharedDBPool: DatabasePool!

/// GSDBManager - Responsible for creating Database
public class GSDBManager {
    public static let sharedGifDBManager = GSDBManager()
    var application = UIApplication.shared

    /// init constructor
    public init() {
        try! setupDatabase(application)
    }

    /// Setup Database
    /// - Parameter application: Application
    /// - Throws: Exception while setup database
    private func setupDatabase(_ application: UIApplication) throws {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as NSString?
        if let databasePath = documentsPath?.appendingPathComponent(giphyDB) {
            _ = try openDatabase(atPath: databasePath)
        }
    }

    /// Creates a fully initialized database at path
    func openDatabase(atPath path: String) throws -> DatabasePool {
        // Connect to the database

        sharedDBPool = try DatabasePool(path: path)

        // Define the database schema
        try migrator.migrate(sharedDBPool)

        return sharedDBPool
    }

    /// The DatabaseMigrator that defines the database schema for Model.
    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("v1.0") { db in

            if let tableColumns = gifTable["columns"] as? [[String: Any]],
                    let tablePrimaryKeys = gifTable["primaryKeys"] as? [String],
                    let tableForeignKeys = gifTable["foreignKey"] as? [String],
                    let tableName = gifTable["tableName"] as? String {
                    try self.createTable(db: db,
                                         tableName: tableName,
                                         columns: tableColumns,
                                         primaryKeys: tablePrimaryKeys,
                                         foreignKeys: tableForeignKeys)
                }
        }

        return migrator
    }

    /// To create Table
    /// - Parameters:
    ///   - db: Database
    ///   - tableName: Table Name
    ///   - columns: Columns
    ///   - primaryKeys: Primary Key
    ///   - foreignKeys: Foreign Key
    /// - Throws: Exception
    func createTable(db: Database, tableName: String, columns: [[String: Any]], primaryKeys: [String], foreignKeys: [String]) throws {
        // Create a table
        try db.create(table: tableName) { table in
            for column in columns {
                if let isPrimaryKey = column["isPrimaryKey"] as? Bool,
                    let columnName = column["columnName"] as? String,
                    let columnType = column["columnType"] as? Database.ColumnType {
                    if isPrimaryKey {
                        table.column(columnName, columnType)
                    } else {
                        table.column(columnName, columnType)
                    }
                }
            }
            if !primaryKeys.isEmpty {
                table.primaryKey(primaryKeys, onConflict: .replace)
            }
        }
    }
}

extension GSDBManager {
    public func getGifDao() -> GSGifDao { return GSGifDao() }
}
