//
//  HomeViewModel.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-16.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var budget: BudgetDTO?
    
    var thisMonthTransactions: [BudgetDTO.Transaction] {
        guard let budget = self.budget else { return [] }
        let transactions = (budget.expenses + budget.income).filter { $0.date.toDate().isCurrentMonthAndYear() }
        return transactions.sorted(by: { $0.date.toDate() > $1.date.toDate() })
    }
    
    var totalBalance: Double {
        guard let budget = self.budget else { return 0 }
        return budget.cards.reduce(0, { $0 + $1.balance })
    }
    
    var totalIncome: Double {
        let thisMonthIncome = thisMonthTransactions.filter { $0.type == .income }
        return total(thisMonthIncome)
    }
    
    var totalExpenses: Double {
        let thisMonthExpenses = thisMonthTransactions.filter { $0.type == .expense }
        return total(thisMonthExpenses)
    }
    
    var spendingSummary: Array<(key: BudgetDTO.Category, value: Double)> {
        var spendingSummary: [BudgetDTO.Category: Double] = [:]
        BudgetDTO.Category.allCases.forEach { category in
            if category == .income { return }
            let categoryExpenses = getMonthSpendings(for: category)
            if categoryExpenses == 0 { return }
            spendingSummary[category] = categoryExpenses
        }
        return spendingSummary.sorted(by: { $0.value < $1.value })
    }

    init(budgetEntity: BudgetModel) {
        self.budget = budgetEntity.budget
    }
    
    private func getMonthSpendings(for category: BudgetDTO.Category) -> Double {
        guard let _ = self.budget else { return 0 }
        let categoryExpenses = thisMonthTransactions.filter { $0.category == category }
        return total(categoryExpenses)
    }
    
    private func total(_ array: [BudgetDTO.Transaction]) -> Double {
        return array.reduce(0, { $0 + $1.amount })
    }
}
