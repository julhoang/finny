//
//  DetailsView.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var budgetEntity: BudgetModel
    @StateObject var viewModel: DetailsViewModel
    
    var body: some View {
        VStack {
            switch budgetEntity.state {
            case .loading: Text("Loading...")
            case .showingContent(let budget):
                    ViewThatFits(in: .vertical) {
                        scrollViewUI(content: budget)
                        ScrollView(showsIndicators: false) { scrollViewUI(content: budget) }
                    }
            case .error(let error): Text(error)
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
        .onAppear {
            viewModel.updateTransactionList()
        }
    }
    
    init(budgetEntity: BudgetModel) {
        let detailsViewModel = DetailsViewModel(budgetEntity: budgetEntity)
        _viewModel = StateObject(wrappedValue: detailsViewModel)
    }
    
    @ViewBuilder
    private func scrollViewUI(content: BudgetDTO) -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Card Details")
                .padding(.leading, 20)
                .font(.title)
                .bold()
            
            cardSection(content: content)
            
            overViewSection()
                .padding(.horizontal, 20)
            
            TransactionsList(title: Date().getMonthString() + " Transactions",
                             transactions: $viewModel.transactions)
                .padding(.horizontal, 20)
            
            Spacer()
        }
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
                        .font(.title3)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Expense")
                        .font(.title3)
                        .bold()
                    Text("$ \(String(format: "%.2f", viewModel.totalExpenses))")
                        .font(.title3)
                        .bold()
                }
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(budgetEntity: BudgetModel())
    }
}
