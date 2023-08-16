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
    @Published var selectedCard: BudgetDTO.CardCompany = .visa
    @Published var allTransactions: [BudgetDTO.Transaction] = []
    @Published var currentMonthTransactions: [BudgetDTO.Transaction] = []
    @Published var otherTransactions: [BudgetDTO.Transaction] = []
    
    var totalIncome: Double {
        let incomes = currentMonthTransactions.filter({ $0.type == .income })
        return incomes.reduce(0, { $0 + $1.amount })
    }
    
    var totalExpenses: Double {
        let expenses = currentMonthTransactions.filter({ $0.type == .expense })
        return expenses.reduce(0, { $0 + $1.amount })
    }
    
    init(budgetEntity: BudgetModel) {
        self.budget = budgetEntity.budget
    }
    
    // Get the list of transactions for the selected card, sorted by most recent
    func updateTransactionLists() {
        guard let budget = self.budget else { return }
        
        self.allTransactions = (budget.expenses + budget.income).filter { $0.cardID == selectedCard }
        
        self.currentMonthTransactions = allTransactions.filter { $0.date.toDate().isCurrentMonthAndYear() }
                                        .sorted(by: { $0.date.toDate() > $1.date.toDate() })
        
        self.otherTransactions = allTransactions.filter { !$0.date.toDate().isCurrentMonthAndYear() }
                                        .sorted(by: { $0.date.toDate() > $1.date.toDate() })
    }
}

