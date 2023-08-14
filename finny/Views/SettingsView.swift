//
//  SettingsView.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel = .init()
    
    var body: some View {
        
        
        List {
            Button("Reset Data") {
                viewModel.resetBudget()
            }
            
            Button("Add Sample Incomes") {
                viewModel.addSampleIncomes()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
