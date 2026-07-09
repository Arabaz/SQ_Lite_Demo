//
//  MainTabBarView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct MainTabBarView: View {

    var body: some View {
        TabView {
            NavigationStack {
                ZStack {
                    Theme.background
                        .ignoresSafeArea()
                    
                    Text("Home Screen")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.primaryText)
                }
                .navigationTitle("Home")
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                ZStack {
                    Theme.background
                        .ignoresSafeArea()
                    
                    Text("Explore Screen")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.primaryText)
                }
                .navigationTitle("Explore")
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}
