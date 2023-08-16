//
//  HomeView.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-15.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var budgetEntity: BudgetModel
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            switch budgetEntity.state {
            case .loading: Text("Loading...")
            case .showingContent(let content):
                ViewThatFits(in: .vertical) {
                    scrollViewUI(content: content)
                    ScrollView(showsIndicators: false) { scrollViewUI(content: content) }
                }
            case .error(let error): Text(error)
            }
        }
        .padding(.horizontal, 20)
    }
    
    init(budgetEntity: BudgetModel) {
        let homeViewModel = HomeViewModel(budgetEntity: budgetEntity)
        _viewModel = StateObject(wrappedValue: homeViewModel)
    }
    
    @ViewBuilder
    private func scrollViewUI(content: BudgetDTO) -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Hi, \(content.user.name)")
                .font(.title)
                .bold()
            
            VStack(alignment: .center) {
                Text("Total Balance")
                    .font(.subheadline)
                
                Text(viewModel.totalBalance.formattedAsCurrency())
            }
            
            categoryOverview()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func categoryOverview() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Category Overview")
                .font(.title)
                .bold()
            
            HStack {
                Text("Income: ")
                Spacer()
                Text(viewModel.totalIncome.formattedAsCurrency())
            }
            .font(.title3)
            .bold()
            

            HStack {
                Text("Expenses: ")
                Spacer()
                Text(viewModel.totalExpenses.formattedAsCurrency())
            }
            .font(.title3)
            .bold()
            
            VStack(spacing: 5) {
                ForEach(viewModel.spendingSummary, id: \.key) { summary in
                    HStack {
                        Text(summary.key.rawValue)
                        Spacer()
                        Text(summary.value.formattedAsCurrency())
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(budgetEntity: BudgetModel())
    }
}
