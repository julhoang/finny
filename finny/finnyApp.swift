//
//  finnyApp.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import SwiftUI

@main
struct finnyApp: App {
    var body: some Scene {
        // set up navigation tab bar
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }
    }
}

