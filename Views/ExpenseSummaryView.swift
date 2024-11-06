//
//  ExpenseSummaryView.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 28..
//
import SwiftUI

struct ExpenseSummaryView: View {
    @ObservedObject var expenseManager: ExpenseManager

    private var expensesByMonthAndCategory: [String: [String: Double]] {
        Dictionary(
            grouping: expenseManager.expenses,
            by: { expense in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy MMMM"
                return formatter.string(from: expense.date)
            }
        ).mapValues { expensesByMonth in
            Dictionary(grouping: expensesByMonth, by: { $0.category })
                .mapValues { expenses in
                    expenses.reduce(0) { $0 + $1.amount }
                }
        }
    }

    var body: some View {
        List {
            ForEach(expensesByMonthAndCategory.keys.sorted(), id: \.self) { month in
                Section(header: Text(month).font(.headline)) {
                    if let categories = expensesByMonthAndCategory[month] {
                        ForEach(categories.keys.sorted(), id: \.self) { category in
                            HStack {
                                Text(category)
                                Spacer()
                                Text(String(format: "$%.2f", categories[category]!))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Monthly Summary")
    }
}
