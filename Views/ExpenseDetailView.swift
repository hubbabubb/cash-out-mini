//
//  ExpenseDetailView.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 28..
//
import SwiftUI

struct ExpenseDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var expenseManager: ExpenseManager
    var expense: Expense
    
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .padding()
                }
                Spacer()
            }
            
            if let receiptImage = expense.receiptImage {
                Image(uiImage: receiptImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(expense.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("$\(expense.amount, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
                
                Text("Category: \(expense.category)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Date: \(expense.date, formatter: dateFormatter)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button(action: {
                showDeleteConfirmation = true
            }) {
                Text("Delete Expense")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Expense"),
                    message: Text("Are you sure you want to delete this expense?"),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteExpense()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding()
    }
    
    private func deleteExpense() {
        if let index = expenseManager.expenses.firstIndex(where: { $0.id == expense.id }) {
            expenseManager.expenses.remove(at: index)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
