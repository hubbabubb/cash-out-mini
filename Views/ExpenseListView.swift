//
//  SwiftUIView.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 26..
//

import SwiftUI
import Charts

struct ExpenseListView: View {
    @ObservedObject var expenseManager: ExpenseManager
    @State private var selectedExpense: Expense?
    var userName: String?
    
    private var groupedExpenses: [String: [Expense]] {
        Dictionary(grouping: expenseManager.expenses.sorted { $0.date < $1.date }) { expense in
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM yyyy"
            return monthFormatter.string(from: expense.date)
        }
    }
    
    private var currentMonthExpenses: [Expense] {
            let calendar = Calendar.current
            return expenseManager.expenses.filter { expense in
                let expenseDate = expense.date
                return calendar.isDate(expenseDate, equalTo: Date(), toGranularity: .month)
            }
        }

        private var categoryTotals: [String: Double] {
            currentMonthExpenses.reduce(into: [String: Double]()) { totals, expense in
                totals[expense.category, default: 0] += expense.amount
            }
        }
    
    struct ClearGroupBoxStyle: GroupBoxStyle {
        func makeBody(configuration: Configuration) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                configuration.label
                configuration.content
            }
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    var body: some View {
        NavigationView {
            List {
                if !categoryTotals.isEmpty {
                    GroupBox("Expenses structure in this month") {
                        Chart {
                            ForEach(categoryTotals.keys.sorted(), id: \.self) { category in
                                let amount = categoryTotals[category] ?? 0
                                SectorMark(
                                    angle: .value("Total", amount),
                                    innerRadius: .ratio(0.5),
                                    outerRadius: .ratio(0.9)
                                )
                                .foregroundStyle(by: .value("Category", category))
                            }
                        }
                        .frame(height: 250)
                        .background(.opacity(0.0))
                    }
                    .groupBoxStyle(ClearGroupBoxStyle())
                }
                
                ForEach(groupedExpenses.keys.sorted(by: <), id: \.self) { month in
                    Section(header: Text(month).font(.title3).bold()) {
                        ForEach(groupedExpenses[month] ?? []) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.title).font(.headline)
                                    Text("\(expense.amount, specifier: "%.2f") $").font(.subheadline)
                                }
                                Spacer()
                                Text(expense.category).font(.footnote).foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                            .onTapGesture {
                                selectedExpense = expense
                            }
                        }
                    }
                }
            
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            if let userName = userName {
                                Text("Hello, \(userName)!")
                                    .font(.headline)
                                    .padding()
                            }
                        }
                    }
                }
            }
            .sheet(item: $selectedExpense) { expense in
                ExpenseDetailView(expense: expense)
            }
        }
    }
}
