//
//  DetailsView.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import SwiftUI

struct DetailsView: View {
    @StateObject var viewModel: DetailsViewModel = .init()
    
    var body: some View {
        VStack {
            if let content = viewModel.budget {
                ViewThatFits(in: .vertical) {
                    scrollViewUI(content: content)
                    ScrollView(showsIndicators: false) { scrollViewUI(content: content) }
                }
            } else {
                Text(viewModel.state)
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
        .onAppear {
            viewModel.getContent()
        }
    }
    
    @ViewBuilder
    private func scrollViewUI(content: BudgetDTO) -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Card Details")
                .padding(.leading, 20)
                .font(.title)
                .bold()
            
            overViewSection()
                .padding(.horizontal, 20)
            
            cardSection(content: content)
            
            TransactionsList(title: Date().getMonthString() + " Transactions",
                             transactions: $viewModel.transactions)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .navigationTitle("Details")
        .onChange(of: viewModel.selectedCard) { _ in
            viewModel.updateTransactionList()
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
                            .padding(.leading, 20)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedCard = card.name
                                    scrollView.scrollTo(card.number, anchor: .center)
                                }
                            }
                    }
                    
                    Spacer()
                        .frame(width: 10)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func overViewSection() -> some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Income")
                        .font(.title3)
                        .bold()
                    Text("$ \(String(format: "%.2f", viewModel.totalIncome))")
                        .font(.title)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Expense")
                        .font(.title3)
                        .bold()
                    Text("$ \(String(format: "%.2f", viewModel.totalExpenses))")
                        .font(.title)
                        .bold()
                }
            }
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

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
