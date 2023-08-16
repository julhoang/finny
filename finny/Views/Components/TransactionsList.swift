//
//  TransactionsList.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-15.
//

import SwiftUI

struct TransactionsList: View {
    @State var title: String
    @Binding var transactions: [BudgetDTO.Transaction]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .bold()
            
            VStack {
                ForEach(transactions, id: \.title) { transaction in
                    HStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(transaction.category.getPastelColor())
                            .frame(width: 45, height: 45)
                            .overlay {
                                Text(transaction.category.rawValue.uppercased().prefix(1))
                            }
                        
                        VStack(alignment: .leading) {
                            Text(transaction.title)
                                .bold()
                            Text(transaction.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()

                        VStack(alignment: .trailing) {
                            if transaction.type == .income {
                                Text(transaction.amount.formattedAsCurrency())
                                    .foregroundColor(.green)
                                    .bold()
                            } else {
                                Text(transaction.amount.invert().formattedAsCurrency())
                                    .bold()
                            }
                            
                            Text(transaction.date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}

struct TransactionsList_Previews: PreviewProvider {
    static let expense1 = BudgetDTO.Transaction(title: "Groceries", category: .food,
                                                amount: 100.0, date: Date().toShortMDYString(),
                                                cardID: .visa, type: .expense)
    static let expense2 = BudgetDTO.Transaction(title: "Gas", category: .transportation,
                                                amount: 50.0, date: Date().toShortMDYString(),
                                                cardID: .visa, type: .expense)
    
    static var previews: some View {
        TransactionsList(title: "August Transactions", transactions: .constant([expense1, expense2]))
    }
}

