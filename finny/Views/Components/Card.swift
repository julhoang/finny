//
//  Card.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import SwiftUI

struct Card: View {
    let card: BudgetDTO.Card
    var isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(card.name.rawValue)
                    .bold()
                Spacer()
                Text("•••• \(card.number)")
            }
            
            Spacer()
            
            Text("Balance")
                .font(.subheadline)
            Text("$ ")
                .font(.title3)
            +
            Text("\(String(format: "%.2f", card.balance))")
                .font(.title)
                .bold()
        }
        .frame(width: 250, height: 100)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(isActive ? card.name == .visa ? .blue : .orange : .gray)
                .opacity(0.5)
        
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(card: .init(name: .visa, number: "1234", balance: 0), isActive: true)
    }
}
