//
//  DatabaseManager.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import Foundation
import SQLite3

final class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTable()
    }

    private func openDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileURL = documentDirectory.appendingPathComponent("users.sqlite")

            if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
                print("Successfully opened database at: \(fileURL.path)")
            } else {
                print("Failed to open SQLite database.")
            }
        } catch {
            print("Error finding document directory: \(error.localizedDescription)")
        }
    }

    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Users (
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Email TEXT UNIQUE,
            FirstName TEXT,
            LastName TEXT,
            Address TEXT,
            Gender TEXT,
            ImagePath TEXT
        );
        """

        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Users table initialized successfully.")
            } else {
                print("Users table failed to initialize.")
            }
        } else {
            print("CREATE TABLE statement preparation failed.")
        }
        sqlite3_finalize(createTableStatement)
    }

    func insertUser(
        email: String,
        firstName: String,
        lastName: String,
        address: String,
        gender: String,
        imagePath: String?
    ) -> Bool {
        let insertQuery = """
        INSERT INTO Users (Email, FirstName, LastName, Address, Gender, ImagePath)
        VALUES (?, ?, ?, ?, ?, ?);
        """

        var insertStatement: OpaquePointer?

        // Prepare the SQL statement
        guard sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK else {
            print("Failed to prepare INSERT statement.")
            return false
        }

        // Bind the parameters (1-indexed)
        sqlite3_bind_text(insertStatement, 1, (email as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStatement, 2, (firstName as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStatement, 3, (lastName as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStatement, 4, (address as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStatement, 5, (gender as NSString).utf8String, -1, nil)

        if let imagePath = imagePath {
            sqlite3_bind_text(insertStatement, 6, (imagePath as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(insertStatement, 6)
        }

        // Execute insert
        let success = sqlite3_step(insertStatement) == SQLITE_DONE
        sqlite3_finalize(insertStatement)

        return success
    }

    func getUser(email: String) -> UserProfile? {
        let query = "SELECT FirstName, LastName, Address, Gender, ImagePath FROM Users WHERE Email = ? LIMIT 1;"
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            print("Failed to prepare user query statement.")
            return nil
        }

        sqlite3_bind_text(statement, 1, (email.lowercased() as NSString).utf8String, -1, nil)

        var profile: UserProfile? = nil

        if sqlite3_step(statement) == SQLITE_ROW {
            let firstName = String(cString: sqlite3_column_text(statement, 0))
            let lastName = String(cString: sqlite3_column_text(statement, 1))
            let address = String(cString: sqlite3_column_text(statement, 2))
            let gender = String(cString: sqlite3_column_text(statement, 3))

            var imagePath: String? = nil
            if let imagePathCol = sqlite3_column_text(statement, 4) {
                imagePath = String(cString: imagePathCol)
            }

            profile = UserProfile(
                email: email,
                firstName: firstName,
                lastName: lastName,
                address: address,
                gender: gender,
                imagePath: imagePath
            )
        }

        sqlite3_finalize(statement)
        return profile
    }

    func checkEmailExists(email: String) -> Bool {
        let query = "SELECT 1 FROM Users WHERE Email = ? LIMIT 1;"
        var statement: OpaquePointer?
        var exists = false

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (email.lowercased() as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_ROW {
                exists = true
            }
        } else {
            print("Failed to prepare checkEmailExists statement.")
        }

        sqlite3_finalize(statement)
        return exists
    }


}
