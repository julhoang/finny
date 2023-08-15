//
//  DetailsViewModel.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import Foundation

@MainActor
class DetailsViewModel: ObservableObject {
    @Published var budget: BudgetDTO?
    var totalIncome: Double {
        let incomes = transactions.filter({ $0.type == .income })
        return incomes.reduce(0, { $0 + $1.amount })
    }
    
    var totalExpenses: Double {
        let expenses = transactions.filter({ $0.type == .expense })
        return expenses.reduce(0, { $0 + $1.amount })
    }

    @Published var newTitle: String = ""
    @Published var newAmount: Double = 0
    @Published var newCategory: BudgetDTO.Category = .food
    @Published var selectedCard: BudgetDTO.CardCompany = .visa
    @Published var state = "Loading..."
    
    @Published var transactions: [BudgetDTO.Transaction] = []
    
    private let fileURL: URL
    
    init() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access Documents directory")
        }
        
        self.fileURL = documentsDirectory.appendingPathComponent("backend.json")
    }
    
    // Read the JSON file and decode it into a BudgetDTO object
    func getContent() {
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let budget = try decoder.decode(BudgetDTO.self, from: jsonData)
            self.budget = budget
            
            updateTransactionList()
        } catch {
            state = "Error loading content"
            print("Error reading or decoding JSON: \(error)")
        }
    }
    
    // Get the list of transactions for the selected card
    func updateTransactionList() {
        guard let budget = budget else { return }
        let currentMonth = Date().toShortMDYString().split(separator: " ")[0]
        let transactions = budget.expenses.filter { $0.cardID == selectedCard } + budget.income.filter { $0.cardID == selectedCard }
        let currentMonthTransactions = transactions.filter { $0.date.split(separator: " ")[0] == currentMonth }
        self.transactions = currentMonthTransactions.sorted(by: { $0.date > $1.date })
    }
    
    // Add a new income to the budget object and write the updated budget object to the JSON file
    func addIncome() {
        guard var budget = self.budget, newAmount != 0 else { return }
        
        let newIncome = BudgetDTO.Transaction(title: newTitle,
                                              category: newCategory,
                                              amount: newAmount,
                                              date: Date().toShortMDYString(),
                                              cardID: selectedCard,
                                              type: .income)
        budget.income.append(newIncome)
        
        if let index = budget.cards.firstIndex(where: { $0.name.rawValue == selectedCard.rawValue }) {
            var updatedCard = budget.cards[index]
            updatedCard.balance += newAmount
            budget.cards[index] = updatedCard
        }
        
        do {
            // Encode the updated budget object
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let updatedJsonData = try encoder.encode(budget)
            try updatedJsonData.write(to: fileURL)
            
            self.budget = budget // Update the budget object in the view model
            
            newTitle = ""
            newAmount = 0
            newCategory = .food
        } catch {
            state = "Error adding income"
            print("\nError writing JSON: \(error)")
        }
    }
}

