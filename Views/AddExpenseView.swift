//
//  AddExpenseView.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 26..
//
import SwiftUI
import UIKit

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenseManager: ExpenseManager
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var date: Date = Date()
    @State private var receiptImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var showSuggestions = false
    @StateObject private var categoryManager = CategoryManager()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $title)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Category", text: $category)
                        .onChange(of: category) { oldVal, newVal in
                            showSuggestions = !category.isEmpty
                        }

                    if (showSuggestions) {
                        List(filteredCategories, id: \.self) { suggestion in
                            Text(suggestion)
                                .onTapGesture {
                                    category = suggestion
                                    showSuggestions = false
                                }
                                .frame(height: 20)
                        }
                        .frame(maxHeight: 200)
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("Receipt Image")) {
                    if let receiptImage = receiptImage {
                        Image(uiImage: receiptImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    Button("Add Receipt Image") {
                        isImagePickerPresented = true
                    }
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExpense()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty || amount.isEmpty || category.isEmpty)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $receiptImage)
            }
        }
    }
    
    private var filteredCategories: [String] {
        categoryManager.savedCategories.filter {
            $0.lowercased().contains(category.lowercased()) && !category.isEmpty
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
                
        let newExpense = Expense(
            title: title,
            amount: amountValue,
            category: category,
            date: date,
            receiptImage: receiptImage
        )
        expenseManager.addExpense(newExpense) // Kiadás mentése az ExpenseManager-rel
        categoryManager.saveCategory(category)
        print("Saved \(categoryManager.savedCategories)")
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    @StateObject static var expenseManager = ExpenseManager()

    @State static var expenses = [Expense]()
    static var previews: some View {
        AddExpenseView(expenseManager: expenseManager)
    }
}
