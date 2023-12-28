//
//  Categories.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(animation: .snappy) private var allCategories: [Category]
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) var allExpenses: [Expense]
    @Environment(\.modelContext) private var context
    @StateObject private var settingsViewModel = SettingsViewModel()
    @Binding var isFloatingButtonClicked: Bool

    @State var addCategory: Bool = false
    @State var categoryName: String = ""
    @State private var deleteRequest: Bool = false
    @State private var isEditingCategory = false

    @State private var requestedCategory: Category?
    @State var addExpense: Bool = false
    @State var setColor: Bool = false
    @State var choosedDate: Date?
    @State private var addedCategory: Category?
    @State private var categoryNames: [String] = []
    @State private var currentTab: String = "Categories"
    @State private var categories: [Category] = []
    @State private var selectedCategory: Category?
    @State private var setCurrency: Bool = false

    
    


//로케일 설정 필요
    func formatCurrency(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""

        if let formattedString = formatter.string(for: amount) {
            return formattedString + "원"
        } else {
            return "\(amount) 원"
        }
    }

    func sortedExpenses(for category: Category) -> [Expense]? {
        return allExpenses.filter { $0.category == category }.sorted(by: { $0.date < $1.date })
    }

    func categoryTotalAmount(category: Category) -> Double {
        let sortedExpenses = allExpenses.filter { $0.category == category }.sorted(by: { $0.date < $1.date })
        return sortedExpenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ZStack{
            NavigationStack {
                List {
                    ForEach(allCategories){ category in
                        CategorySectionView(category: category)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    deleteRequest.toggle()
                                    requestedCategory = category
                                    
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.delete)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    editCategory(category)
                                } label: {
                                    Image(systemName: "pencil")
                                        .fontWeight(.bold)
                                }
                                .tint(.edit)
                            }
                    }
                }
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu(content: {
                            Button {
                                setCurrency.toggle()
                                isFloatingButtonClicked = false
                            }
                        label: {
                            //systemImage를 달러, 엔, 원 으로 사용자 설정값에 맞게 바뀌도록하기
                            Label("통화 설정", systemImage: "dollarsign")
                        }
                        .sheet(isPresented: $setCurrency) {
                            CurrencySettingView()
                                .interactiveDismissDisabled()
                        }
                            Button {
                                setColor.toggle()
                                isFloatingButtonClicked = false
                            }
                        label: {
                            Label("카테고리 테마 지정", systemImage: "paintpalette")
                        }
                        .sheet(isPresented: $setColor) {
                            CategoryThemeSettingView()
                                .interactiveDismissDisabled()
                        }
                            Button {
                                addCategory.toggle()
                                isFloatingButtonClicked = false

                            }
                        label: {
                            Label("카테고리 추가", systemImage: "square.grid.3x1.folder.badge.plus")
                        }
                        .sheet(isPresented: $addCategory) {
                        }
                            Button {
                                addExpense.toggle()
                                isFloatingButtonClicked = false

                            }
                        label: {
                            Label("내역 추가", systemImage: "note.text.badge.plus")
                        }
                        .sheet(isPresented: $addExpense) {
                            AddExpenseView()
                                .interactiveDismissDisabled()
                        }
                        }) {
                            Image(systemName: "plus")
                                
                            
                        }
                    }
                })

                .navigationTitle("카테고리")
                .overlay(content: {
                    if allCategories.isEmpty {
                        ContentUnavailableView {
                            Label("생성된 카테고리가 없습니다", systemImage: "tray.fill")
                        }
                    }
                })
                .onAppear {
                    settingsViewModel.categoryNames = allCategories.map { $0.categoryName }
                    categories = allCategories
                }
                .onChange(of: allCategories) { updatedCategories in
                    settingsViewModel.categoryNames = updatedCategories.map { $0.categoryName }
                    settingsViewModel.Changed.toggle()
                    saveContext()
                }
                .sheet(isPresented: $addCategory) {
                    AddCategorySheetView(categoryName: $categoryName, addCategory: $addCategory)
                }
            }
//            FloatingButtonView(addExpense: $addExpense, addCategory: $addCategory, setColor: $setColor, setCurrency: $setCurrency, isFloatingButtonClicked: $isFloatingButtonClicked)
            
        }
        .alert("카테고리 삭제시 카테고리에 지정된 내역들도 삭제됩니다. 정말 삭제하시겠습니까?", isPresented: $deleteRequest) {
            Button(role: .destructive) {
                if let requestedCategory = requestedCategory {
                    let expensesToDelete = allExpenses.filter { $0.category == requestedCategory }
                    expensesToDelete.forEach { context.delete($0) }
                    context.delete(requestedCategory)
                    self.requestedCategory = nil
                }
            } label: {
                Text("삭제")
            }

            Button(role: .cancel) {
                requestedCategory = nil
            } label: {
                Text("취소")
            }
        }
        .sheet(isPresented: $addExpense) {
            AddExpenseView()
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $setColor) {
            CategoryThemeSettingView()
                .interactiveDismissDisabled()
        }
        .sheet(item: $selectedCategory) { category in
            EditCategorySheetView(category: category, categoryName: $categoryName, addCategory: $addCategory)
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $setCurrency) {
            CurrencySettingView()
                .interactiveDismissDisabled()
        }
       
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    func editCategory(_ category: Category) {
        selectedCategory = category
        isEditingCategory.toggle()
    }
    
}

struct CategorySectionView: View {
    @StateObject private var settingsViewModel = SettingsViewModel.shared
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) var allExpenses: [Expense]
    @State var addExpense: Bool = false



    let category: Category

    func formatCurrency(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""

        if let formattedString = formatter.string(for: amount) {
            return formattedString + "원"
        } else {
            return "\(amount) 원"
        }
    }

    func sortedExpenses(for category: Category) -> [Expense]? {
        return allExpenses.filter { $0.category == category }.sorted(by: { $0.date < $1.date })
    }

    func categoryTotalAmount(category: Category) -> Double {
        let sortedExpenses = allExpenses.filter { $0.category == category }.sorted(by: { $0.date < $1.date })
        return sortedExpenses.reduce(0) { $0 + $1.amount }
    }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy.MM.dd"
        return formatter
    }()

    var body: some View {
        Section {
            DisclosureGroup {
                if let sortedExpenses = sortedExpenses(for: category) {
                    ForEach(sortedExpenses.indices, id: \.self) { index in
                        let expense = sortedExpenses[index]
                        HStack {
                            Text(expense.date, formatter: dateFormatter)
                                .textScale(.secondary)
                            ExpenseCardView(expense: expense, displayTag: false)
                                .environmentObject(settingsViewModel)
                        }

                        if index == sortedExpenses.indices.last {
                            HStack {
                                Text("합계:")
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text(formatCurrency(amount: categoryTotalAmount(category: category)))
                                    .foregroundColor(categoryTotalAmount(category: category) >= 0 ? .incomeAmount : .expenseAmount)
                            }
                        }
                    }
                    if !addExpense && sortedExpenses.indices.last == 0 {
                        HStack {
                            Spacer()
                        }
                    }
                } else {
                    ContentUnavailableView {
                        Label("목록이 비어있습니다", systemImage: "tray.fill")
                    }
                }
            } label: {
                Text(category.categoryName)
            }
        }
    }
}


//
//#Preview {
//    CategoriesView()
//}
