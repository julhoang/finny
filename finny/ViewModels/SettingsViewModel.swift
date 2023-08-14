//
//  SettingsViewModel.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import Foundation

class SettingsViewModel: ObservableObject {
    let user = BudgetDTO.User(name: "Julia Hoang", email: "")
    
    init() {}
    
    func resetBudget() {
        let card1 = BudgetDTO.Card(name: .visa, number: "1234", balance: 0.0)
        let card2 = BudgetDTO.Card(name: .mastercard, number: "5678", balance: 0.0)
        let budget = BudgetDTO(user: user, cards: [card1, card2], income: [], expenses: [])
        updateJSON(newBudget: budget)
    }
    
    func addSampleIncomes() {
        let income1 = BudgetDTO.Transaction(title: "Paycheck", category: .income, amount: 1000.0, date: Date().toString(), cardID: .visa)
        let income2 = BudgetDTO.Transaction(title: "Paycheck 2", category: .income, amount: 500.0, date: Date().toString(), cardID: .mastercard)
        
        let card1 = BudgetDTO.Card(name: .visa, number: "1234", balance: income1.amount)
        let card2 = BudgetDTO.Card(name: .mastercard, number: "5678", balance: income2.amount)
        
        let budget = BudgetDTO(user: user, cards: [card1, card2], income: [income1, income2], expenses: [])
        updateJSON(newBudget: budget)
    }
    
    func updateJSON(newBudget: BudgetDTO) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(newBudget)
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("backend.json")
            try jsonData.write(to: fileURL)
        } catch {
            print("Error reseting JSON: \(error)")
        }
    }
}
