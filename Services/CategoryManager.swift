//
//  File.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 27..
//
import Foundation

class CategoryManager: ObservableObject {
    @Published var savedCategories: [String] = []

    init() {
        loadCategories()
    }

    func loadCategories() {
        savedCategories = UserDefaults.standard.stringArray(forKey: "savedCategories") ?? []
    }

    func saveCategory(_ category: String) {
        if !savedCategories.contains(category) {
            savedCategories.append(category)
            UserDefaults.standard.set(savedCategories, forKey: "savedCategories")
        }
    }
}
