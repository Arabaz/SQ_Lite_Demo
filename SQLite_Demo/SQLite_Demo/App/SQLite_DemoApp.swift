//
//  SQLite_DemoApp.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 06/07/26.
//

import SwiftUI

@main
struct SQLite_DemoApp: App {
    @StateObject private var session = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
        }
    }
}
