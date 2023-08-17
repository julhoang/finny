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
        var visaBalance: Double = 10000
        var mastercardBalance: Double = 7000
        
        var allIncomes = [BudgetDTO.Transaction]()
        var allExpenses = [BudgetDTO.Transaction]()
        
        typealias TransactionData = (title: String, category: BudgetDTO.Category,
                                     amount: Double, date: String, cardID: BudgetDTO.CardCompany)
        
        let incomeData: [TransactionData] = [
            ("Paycheck", .income, 1000.0, "Aug 15, 23", .visa),
            ("Paycheck 2", .income, 500.0, "Aug 17, 23", .mastercard),
            ("Bonus", .income, 2000.0, "Aug 31, 23", .visa),
            ("Freelance work", .income, 800.0, "Aug 25, 23", .mastercard),
            ("Investment dividends", .income, 300.0, "Aug 20, 23", .visa),
            ("Side hustle", .income, 400.0, "Aug 10, 23", .mastercard),
            ("Gift", .income, 100.0, "Aug 05, 23", .visa),
            ("Refund", .income, 250.0, "Aug 01, 23", .mastercard),
            ("Rental income", .income, 600.0, "July 25, 23", .visa),
            ("Paycheck", .income, 1000.0, "July 15, 23", .mastercard),
            ("Paycheck 2", .income, 500.0, "July 17, 23", .visa),
            ("Bonus", .income, 2000.0, "July 31, 23", .mastercard),
            ("Freelance work", .income, 800.0, "July 25, 23", .visa),
            ("Investment dividends", .income, 300.0, "July 20, 3", .mastercard),
            ("Side hustle", .income, 400.0, "July 10, 23", .visa),
            ("Gift", .income, 100.0, "July 05, 23", .mastercard),
            ("Refund", .income, 250.0, "July 01, 23", .visa),
            ("Rental income", .income, 600.0, "June 25, 23", .visa),
            ("Paycheck 2", .income, 500.0, "June 17, 23", .mastercard)
        ]
        
        for income in incomeData {
            let transaction = BudgetDTO.Transaction(title: income.0,
                                                    category: income.1,
                                                    amount: income.2,
                                                    date: income.3,
                                                    cardID: income.4,
                                                    type: .income)
            allIncomes.append(transaction)
            
            if income.cardID == .visa {
                visaBalance += income.amount
            } else {
                mastercardBalance += income.amount
            }
        }
        
        let expenseData: [TransactionData] = [
            ("Groceries", .food, 100.0, "Aug 11, 23", .visa),
            ("Coffee", .food, 5.0, "Aug 07, 23", .visa),
            ("Gas for 2nd car", .transportation, 50.0, "Aug 01 23", .mastercard),
            ("Rent", .housing, 1000.0, "Jul 31, 23", .visa),
            ("Mortgage", .housing, 1000.0, "Jul 19, 23", .mastercard),
            ("Internet", .bills, 100.0, "Jul 11, 23", .visa),
            ("Heat", .bills, 100.0, "June 29, 23", .mastercard),
            ("Restaurant", .food, 30.0, "June 18, 23", .mastercard),
            ("Car insurance", .bills, 200.0, "June 12,23",.mastercard),
            ("Phone bill", .bills, 70.0, "May 25, 23", .visa),
            ("Travel", .other, 5000, "May 02, 23", .mastercard),
            ("Books", .entertainment, 40.0, "Apr 01, 23", .visa),
            ("Groceries", .food, 100.0, "Mar 11, 23", .visa),
            ("Coffee", .food, 5.0, "Mar 05, 23", .visa),
            ("Gas for 2nd car", .transportation, 50.0, "Feb 11, 23", .mastercard),
            ("Rent", .housing, 10000, "Jan 31, 23", .visa),
            ("Mortgage", .housing, 1000.0, "Jan 19, 23", .mastercard),
        ]
        
        for expense in expenseData {
            let transaction = BudgetDTO.Transaction(title: expense.0,
                                                    category: expense.1,
                                                    amount: expense.2,
                                                    date: expense.3,
                                                    cardID: expense.4,
                                                    type: .expense)
            allExpenses.append(transaction)
            
            if expense.cardID == .visa {
                visaBalance -= expense.amount
            } else {
                mastercardBalance -= expense.amount
            }
        }
        
        let visaCard = BudgetDTO.Card(name: .visa, number: "1234", balance: visaBalance)
        let mastercard = BudgetDTO.Card(name: .mastercard, number: "5678", balance: mastercardBalance)
        
        let budget = BudgetDTO(user: user, cards: [visaCard, mastercard], income: allIncomes, expenses: allExpenses)
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
