//
//  finnyApp.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import SwiftUI

@main
struct finnyApp: App {
    @StateObject var budgetEntity: BudgetModel = .init()
    
    var body: some Scene {
        // set up navigation tab bar
        WindowGroup {
            TabView {
                HomeView(budgetEntity: budgetEntity)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                DetailsView(budgetEntity: budgetEntity)
                    .tabItem {
                        Image(systemName: "number.square")
                        Text("Details")
                    }
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .environmentObject(budgetEntity)
        }
    }
}

