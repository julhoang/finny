//
//  HomeView.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            if let content = viewModel.budget {
                topNavBar(content: content)
                
                cardSection(content: content)
                
                Spacer()
                
                Text("Total Income: $\(String(format: "%.2f", viewModel.totalIncome))")
                Text("Total Expenses: $\(String(format: "%.2f", viewModel.totalExpenses))")
                
                Spacer()
                
                ForEach(content.income, id: \.title) { income in
                    if income.cardID.rawValue == viewModel.selectedCard.rawValue {
                        HStack {
                            Text(income.title)
                            Text("$\(String(format: "%.2f", income.amount))")
                            Text(income.date)
                        }
                    }
                }
                
                Spacer()
                
                inputSection()
            } else {
                Text("Loading...")
            }
        }
        .padding()
        .onAppear {
            viewModel.getContent()
        }
    }
    
    @ViewBuilder
    private func topNavBar(content: BudgetDTO) -> some View {
        HStack {
            Text("Hi, \(content.user.name)")
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func cardSection(content: BudgetDTO) -> some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(content.cards, id: \.number) { card in
                        Card(card: card, isActive: card.name == viewModel.selectedCard)
                            .id(card.number)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedCard = card.name
                                    scrollView.scrollTo(card.number, anchor: .center)
                                }
                            }
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func inputSection() -> some View {
        TextField("New Transaction", text: $viewModel.newTitle)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
        TextField("New Amount", value: $viewModel.newAmount, formatter: NumberFormatter())
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Picker(selection: $viewModel.newCategory, label: Text("Category")) {
            ForEach(BudgetDTO.Category.allCases, id: \.self) { category in
                Text(category.rawValue).tag(category)
            }
        }
        
        Button("Add Income") {
            viewModel.addIncome()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
