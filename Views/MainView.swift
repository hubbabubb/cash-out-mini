//
//  MainView.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 26..
//
import SwiftUI

struct MainView: View {
    @State private var isAddExpenseViewPresented = false
    @State private var isLoginViewPresented = false
    @StateObject private var expenseManager = ExpenseManager()
    @State private var isUserLoggedIn = false
    @State private var userName: String? = nil
    @State private var isDarkMode = false
    

    var body: some View {
        ZStack {
            isDarkMode ? Color.black : Color.white
            VStack {
                TabView {
                    NavigationView {
                        ExpenseListView(expenseManager: expenseManager, userName: userName)
                            .environmentObject(expenseManager)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    Image("Logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                }
                                if !isUserLoggedIn {
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        Button(action: {
                                            isLoginViewPresented = true
                                        }) {
                                            Image(systemName: "person.circle")
                                                .font(.title)
                                        }
                                    }
                                } else {
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                isDarkMode.toggle()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                    toggleUserInterfaceStyle(isDark: isDarkMode)
                                                }
                                            }
                                        }) {
                                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                                .font(.title)
                                                .foregroundColor(isDarkMode ? .yellow : .blue)
                                        }
                                        .padding()
                                        .background(
                                            ZStack {
                                                Circle()
                                                    .fill(isDarkMode ? Color.black : Color.white)
                                                    .scaleEffect(isDarkMode ? 3 : 0)
                                                    .animation(.easeInOut(duration: 0.5), value: isDarkMode)
                                            }
                                        )
                                    }
                                }
                            
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        isAddExpenseViewPresented = true
                                    }) {
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            .sheet(isPresented: $isLoginViewPresented) {
                                LoginView(isUserLoggedIn: $isUserLoggedIn, userName: $userName)
                            }
                            .sheet(isPresented: $isAddExpenseViewPresented) {
                                AddExpenseView(expenseManager: expenseManager)
                            }
                    }
                    .tabItem {
                        Label("Expenses", systemImage: "list.bullet")
                    }

                    NavigationView {
                        ExpenseSummaryView(expenseManager: expenseManager)
                    }
                    .tabItem {
                        Label("Summary", systemImage: "chart.bar.fill")
                    }
                }
            }
        }
    }
    
    private func toggleUserInterfaceStyle(isDark: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(ExpenseManager())
    }
}
