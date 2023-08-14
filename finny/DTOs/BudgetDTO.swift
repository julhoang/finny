//
//  BudgetDTO.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import Foundation

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
    
    enum CardCompany: String, Codable {
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
    }
    
    struct Transaction: Codable {
        let title: String
        let category: Category?
        let amount: Double
        let date: String
        let cardID: CardCompany
    }
    
    let user: User
    var cards: [Card]
    var income: [Transaction]
    var expenses: [Transaction]
}
