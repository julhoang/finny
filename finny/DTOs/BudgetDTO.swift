//
//  BudgetDTO.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import Foundation
import SwiftUI

struct BudgetDTO: Codable {
    struct User: Codable {
        let name: String
        let email: String
    }
    
    struct Card: Codable {
        let name: CardCompany
        let number: String // 4 digits, also ID
        var balance: Double
    }
    
    enum CardCompany: String, Codable, Equatable {
        case visa = "Visa"
        case mastercard = "Mastercard"
    }
    
    enum Category: String, Codable, CaseIterable {
        case housing = "Housing"
        case food = "Food"
        case bills = "Bills"
        case transportation = "Transportation"
        case entertainment = "Entertainment"
        case shopping = "Shopping"
        
        case income = "Income"
        
        case other = "Other"
        
        func getPastelColor() -> Color {
            switch self {
            case .housing:
                return Color(red: 0.88, green: 0.71, blue: 0.75)
            case .food:
                return Color(red: 0.73, green: 0.88, blue: 0.88)
            case .bills:
                return Color(red: 088, green: 0.7, blue: 0.75)
            case .transportation:
                return Color(red: 0.75, green: 0.78, blue: 0.88)
            case .entertainment:
                return Color(red: 0.87, green: 0.77, blue: 0.87)
            case .shopping:
                return Color(red: 0.77, green: 0.87, blue: 0.77)
            case .income:
                return Color(red: 0.87, green: 0.87, blue: 0.77)
            case .other:
                return Color.gray
            }
        }
    }
    
    enum TransactionType: String, Codable {
        case income = "Income"
        case expense = "Expenses"
    }
    
    struct Transaction: Codable {
        let title: String
        let category: Category
        let amount: Double
        let date: String
        let cardID: CardCompany
        let type: TransactionType
    }
    
    let user: User
    var cards: [Card]
    var income: [Transaction]
    var expenses: [Transaction]
}
