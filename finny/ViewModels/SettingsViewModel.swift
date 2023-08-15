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
    
    func addSampleTransactions() {
        let income1 = BudgetDTO.Transaction(title: "Paycheck", category: .income, amount: 1000.0, date: "Aug 15, 2023", cardID: .visa, type: .income)
        let income2 = BudgetDTO.Transaction(title: "Paycheck 2", category: .income, amount: 500.0, date: "Aug 17, 2023", cardID: .mastercard, type: .income)
        
        let expense1 = BudgetDTO.Transaction(title: "Groceries", category: .food, amount: 100.0, date: "Aug 11, 2023", cardID: .visa, type: .expense)
        let expense2 = BudgetDTO.Transaction(title: "Coffee", category: .food, amount: 5.0, date: "Aug 10, 2023", cardID: .mastercard, type: .expense)
        let expense3 = BudgetDTO.Transaction(title: "Gas", category: .transportation, amount: 50.0, date: "Aug 05, 2023", cardID: .visa, type: .expense)
        let expense4 = BudgetDTO.Transaction(title: "Gas for 2nd car", category: .transportation, amount: 50.0, date: "Jul 11, 2023", cardID: .mastercard, type: .expense)
        let expense5 = BudgetDTO.Transaction(title: "Rent", category: .housing, amount: 1000.0, date: "Jul 31, 2023", cardID: .visa, type: .expense)
        let expense6 = BudgetDTO.Transaction(title: "Mortgage", category: .housing, amount: 1000.0, date: "Jul 19, 2023", cardID: .mastercard, type: .expense)
        let expense7 = BudgetDTO.Transaction(title: "Internet", category: .bills, amount: 100.0, date: "June 11, 2023", cardID: .visa, type: .expense)
        let expense8 = BudgetDTO.Transaction(title: "Heat", category: .bills, amount: 100.0, date: "May 01, 2023", cardID: .mastercard, type: .expense)
        
        let allIncomes = [income1, income2]
        let allExpenses = [expense1, expense2, expense3, expense4, expense5, expense6, expense7, expense8]
        
        let card1 = BudgetDTO.Card(name: .visa, number: "1234",
                                   balance: 10000.00 - (expense1.amount + expense3.amount + expense5.amount + expense7.amount) + income1.amount)
        let card2 = BudgetDTO.Card(name: .mastercard, number: "5678",
                                   balance: 7000.00 - (expense2.amount + expense4.amount + expense6.amount + expense8.amount) + income2.amount)
        
        
        let budget = BudgetDTO(user: user, cards: [card1, card2], income: allIncomes, expenses: allExpenses)
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
