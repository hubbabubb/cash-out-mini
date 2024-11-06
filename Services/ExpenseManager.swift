//
//  ExpenseManager.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 28..
//

import Foundation

class ExpenseManager: ObservableObject {
    @Published var expenses: [Expense] = []
    
    private let userDefaultsKey = "savedExpenses"
    
    init() {
        loadExpenses()
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }
    
    func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func loadExpenses() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedExpenses = try? JSONDecoder().decode([Expense].self, from: savedData) {
            expenses = decodedExpenses
        }
    }
}
