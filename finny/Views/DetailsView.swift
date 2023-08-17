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
            viewModel.updateTransactionLists()
        }
    }
    
    init(budgetEntity: BudgetModel) {
        let detailsViewModel = DetailsViewModel(budgetEntity: budgetEntity)
        _viewModel = StateObject(wrappedValue: detailsViewModel)
    }
    
    private func scrollViewUI(content: BudgetDTO) -> some View {
         VStack(alignment: .leading, spacing: 30) {
             Text("Transaction Details")
                 .font(.title)
                 .bold()
                 .padding(.horizontal, 20)

             cardSection(content: content)
             
             VStack(spacing: 30) {
                 overViewSection()

                 TransactionsList(title: Date().getMonthString() + " Transactions",
                                  transactions: $viewModel.currentMonthTransactions)

                 TransactionsList(title: "Older Transactions",
                                  transactions: $viewModel.otherTransactions)

                 Spacer()
             }
             .padding(.horizontal, 20)
             
         }
         .onChange(of: viewModel.selectedCard) { _ in
             viewModel.updateTransactionLists()
         }
     }
    
    @ViewBuilder
    private func cardSection(content: BudgetDTO) -> some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(content.cards, id: \.number) { card in
                        Card(card: card, isActive: card.name == viewModel.selectedCard)
                            .id(card.number)
                            
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
                .padding(.leading, 20)
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: viewModel.selectedCard)
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
                    Text(viewModel.totalIncome.formattedAsCurrency())
                        .font(.title3)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Expense")
                        .font(.title3)
                        .bold()
                    Text(viewModel.totalExpenses.formattedAsCurrency())
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
