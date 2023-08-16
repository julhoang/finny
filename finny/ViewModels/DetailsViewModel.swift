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
    @Published var transactions: [BudgetDTO.Transaction] = []
    
    var totalIncome: Double {
        let incomes = transactions.filter({ $0.type == .income })
        return incomes.reduce(0, { $0 + $1.amount })
    }
    
    var totalExpenses: Double {
        let expenses = transactions.filter({ $0.type == .expense })
        return expenses.reduce(0, { $0 + $1.amount })
    }
    
    init(budgetEntity: BudgetModel) {
        self.budget = budgetEntity.budget
    }
    
    // Get the list of transactions for the selected card, sorted by most recent
    func updateTransactionList() {
        guard let budget = self.budget else { return }
        let transactions = budget.expenses.filter { $0.cardID == selectedCard } + budget.income.filter { $0.cardID == selectedCard }
        let currentMonthTransactions = transactions.filter { $0.date.toDate().isCurrentMonthAndYear() }
        self.transactions = currentMonthTransactions.sorted(by: { $0.date.toDate() > $1.date.toDate() })
    }
}


