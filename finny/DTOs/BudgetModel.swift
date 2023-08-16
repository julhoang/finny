//
//  BudgetModel.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-16.
//

import Foundation

class BudgetModel: ObservableObject {
    enum FetchingState {
        case loading
        case showingContent(BudgetDTO)
        case error(String)
    }
    
    @Published var budget: BudgetDTO?
    @Published var state: FetchingState = .loading

    private let fileURL: URL
    
    init() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access Documents directory")
        }
        
        self.fileURL = documentsDirectory.appendingPathComponent("backend.json")
    
        loadBudget()
    }
    
    func loadBudget() {
        do {
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: fileURL)
            budget = try decoder.decode(BudgetDTO.self, from: jsonData)
            
            if let budget {
                self.state = .showingContent(budget)
            }
        } catch {
            print("\nError reading JSON: \(error)")
            self.state = .error("Error reading JSON")
        }
    }
}
