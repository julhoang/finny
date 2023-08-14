//
//  HomeViewModel.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var budget: BudgetDTO?
    var totalIncome: Double {
        guard let budget = budget else { return 0 }
        return budget.income.reduce(0, { $0 + $1.amount })
    }
    
    var totalExpenses: Double {
        guard let budget = budget else { return 0 }
        return budget.expenses.reduce(0, { $0 + $1.amount })
    }
    
    @Published var newTitle: String = ""
    @Published var newAmount: Double = 0
    @Published var newCategory: BudgetDTO.Category = .food
    @Published var selectedCard: BudgetDTO.CardCompany = .visa
    
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
        } catch {
            print("Error reading or decoding JSON: \(error)")
        }
    }
    
    // Add a new income to the budget object and write the updated budget object to the JSON file
    func addIncome() {
        guard var budget = self.budget, newAmount != 0 else { return }
        
        let newIncome = BudgetDTO.Transaction(title: newTitle,
                                              category: newCategory,
                                              amount: newAmount,
                                              date: Date().toString(),
                                              cardID: selectedCard)
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
            print("\nError writing JSON: \(error)")
        }
    }
}

