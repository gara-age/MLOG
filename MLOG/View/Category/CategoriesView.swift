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
    @State private var selectedExpense: Expense?
    @State private var isEditingExpense = false
    
    @State private var selectedDateFilter: DateFilter = .all
    @State private var selectedSortOrder: SortOrder = .latestFirst
    @State private var selectedTransactionType: TransactionTypeFilter = .all
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var latestFirst : Bool = true
    @State private var oldestFirst : Bool = false
    @State private var customDate : String = "직접 설정"
    @State private var showFilterView : Bool = false
    @State private var filteredExpenses: [GroupedExpenses] = []
        @State private var isSearching = false
    @State  var groupedExpenses: [GroupedExpenses] = []
    @State  var originalGroupedExpenses: [GroupedExpenses] = []
    @State  var searchText: String = ""
    @State private var expenseToDelete: Expense?
    @State private var showCategoryThemeSettingView = false
    @Binding var isFloatingButtonClicked: Bool

    
    enum DateFilter: String, CaseIterable {
        
        case all = "전체 내역"
        case oneMonth = "1개월"
        case threeMonths = "3개월"
        case lastMonth = "지난달"
        case custom = "직접 설정"
        
        var startDate: Date {
                switch self {
                case .custom:
                    return .now.startOfMonth
                default:
                    return .now
                }
            }
            
            var endDate: Date {
                switch self {
                case .custom:
                    return .now.endOfMonth
                default:
                    return .now
                }
            }
           
           var displayString: String {
               switch self {
               default:
                   return rawValue
               }
           }
        func format(date : Date, format : String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: date)
            
        
            
        }
    }
    
    enum SortOrder: String, CaseIterable {
        case latestFirst = "최신순"
        case oldestFirst = "과거순"
        
        static var defaultSortOrder: SortOrder = .latestFirst

    }
    
    enum TransactionTypeFilter: String, CaseIterable {
        case all = "전체"
        case incomeOnly = "수입만"
        case expenseOnly = "지출만"
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
                            
                    }
                }
//                .toolbar(content: {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Menu(content: {
//                            Button {
//                                addExpense.toggle()
//                                 
//
//                            }
//                        label: {
//                            Label("내역 추가", systemImage: "note.text.badge.plus")
//                        }
//                        .sheet(isPresented: $addExpense) {
//                            AddExpenseView()
//                                .interactiveDismissDisabled()
//                        }
//                            
//                            Button {
//                                addCategory.toggle()
//                                 
//
//                            }
//                        label: {
//                            Label("카테고리 추가", systemImage: "square.grid.3x1.folder.badge.plus")
//                        }
//                        .sheet(isPresented: $addCategory) {
//                            AddCategorySheetView(
//                                categoryName: $categoryName,
//                                addCategory: $addCategory,
//                                showCategoryThemeSettingView: $showCategoryThemeSettingView
//                            )
//                        }
//                         
//                            
//                            Button {
//                                showCategoryThemeSettingView.toggle()
//                                 
//                            }
//                        label: {
//                            Label("카테고리 테마 지정", systemImage: "paintpalette")
//                        }
//                        .sheet(isPresented: $showCategoryThemeSettingView) {
//                            CategoryThemeSettingView()
//                                .interactiveDismissDisabled()
//                        }
//                        
//                            
//                            Button {
//                                setCurrency.toggle()
//                                 
//                            }
//                        label: {
//                            //systemImage를 달러, 엔, 원 으로 사용자 설정값에 맞게 바뀌도록하기
//                            Label("통화 설정", systemImage: "dollarsign")
//                        }
//                        .sheet(isPresented: $setCurrency) {
//                            CurrencySettingView()
//                                .interactiveDismissDisabled()
//                        }
//                        }) {
//                            Image(systemName: "plus")
//                                
//                            
//                        }
//                    }
//                })
                .navigationTitle("카테고리")
                .navigationBarTitleDisplayMode(.inline)

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
               

            }
            FloatingButtonView(addExpense: $addExpense, addCategory: $addCategory, showCategoryThemeSettingView : $showCategoryThemeSettingView, setCurrency: $setCurrency, isFloatingButtonClicked: $isFloatingButtonClicked)
                

        }
       
        .sheet(isPresented: $addExpense) {
            AddExpenseView()
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $showCategoryThemeSettingView) {
            CategoryThemeSettingView()
                .interactiveDismissDisabled()
        }
        
        .sheet(isPresented: $setCurrency) {
            CurrencySettingView()
                .interactiveDismissDisabled()
        }
        
        .sheet(isPresented: $addCategory) {
            AddCategorySheetView(
                categoryName: $categoryName,
                addCategory: $addCategory,
                showCategoryThemeSettingView: $showCategoryThemeSettingView
            )
        }
       
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    
}

struct CategorySectionView: View {
    @StateObject private var settingsViewModel = SettingsViewModel.shared
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) var allExpenses: [Expense]
    @AppStorage("selectedCurrency") private var selectedCurrency: String?

    @State var addExpense: Bool = false
    @State private var selectedExpense: Expense?
    @State private var isEditingExpense = false
    @Environment(\.modelContext)  var context
    @State  var groupedExpenses: [GroupedExpenses] = []
    @State private var deleteRequest: Bool = false
    @State private var requestedCategory: Category?
    @State private var selectedCategory: Category?
    @State private var isEditingCategory = false
    @State private var expenseDeleteRequest: Bool = false
    

    @State private var selectedDateFilter: DateFilter = .all
    @State private var selectedSortOrder: SortOrder = .latestFirst
    @State private var selectedTransactionType: TransactionTypeFilter = .all
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var latestFirst : Bool = true
    @State private var oldestFirst : Bool = false
    @State private var customDate : String = "직접 설정"
    @State private var showFilterView : Bool = false
    @State private var filteredExpenses: [GroupedExpenses] = []
    @State private var isSearching = false
    @State  var originalGroupedExpenses: [GroupedExpenses] = []
    @State  var searchText: String = ""
    @State var addCategory: Bool = false
    @State var categoryName: String = ""
    @State private var expenseToDelete: Expense?

    
    enum DateFilter: String, CaseIterable {
        
        case all = "전체 내역"
        case oneMonth = "1개월"
        case threeMonths = "3개월"
        case lastMonth = "지난달"
        case custom = "직접 설정"
        
        var startDate: Date {
                switch self {
                case .custom:
                    return .now.startOfMonth
                default:
                    return .now
                }
            }
            
            var endDate: Date {
                switch self {
                case .custom:
                    return .now.endOfMonth
                default:
                    return .now
                }
            }
           
           var displayString: String {
               switch self {
               default:
                   return rawValue
               }
           }
        func format(date : Date, format : String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: date)
            
        
            
        }
    }
    
    enum SortOrder: String, CaseIterable {
        case latestFirst = "최신순"
        case oldestFirst = "과거순"
        
        static var defaultSortOrder: SortOrder = .latestFirst

    }
    
    enum TransactionTypeFilter: String, CaseIterable {
        case all = "전체"
        case incomeOnly = "수입만"
        case expenseOnly = "지출만"
    }
    
    func updateExpenses(_ expenses: [Expense], searchText: String) {

        Task.detached(priority: .high) {
            var filteredExpenses: [Expense]
            let latestFirstValue = await latestFirst
            
            // 선택된 필터에 따라 내역을 필터링
            switch await selectedDateFilter {
            case .oneMonth:
                // 현재 날짜로부터 30일 이내의 내역
                let oneMonthAgo = Calendar.current.date(byAdding: .day, value: -31, to: Date()) ?? Date()
                filteredExpenses = expenses.filter { $0.date >= oneMonthAgo && $0.date <= Date() }
            case .threeMonths:
                // 현재 날짜로부터 90일 이내의 내역
                let threeMonthsAgo = Calendar.current.date(byAdding: .day, value: -91, to: Date()) ?? Date()
                filteredExpenses = expenses.filter { $0.date >= threeMonthsAgo && $0.date <= Date() }
            case .lastMonth:
                // 지난달의 첫날과 마지막날을 계산
                let calendar = Calendar.current
                let currentDate = Date()
                let firstDayOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) ?? Date()
                let lastMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfCurrentMonth) ?? Date()
                let firstDayOfLastMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfCurrentMonth) ?? Date()
                let lastDayOfLastMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfCurrentMonth) ?? Date()
                
                // 지난달의 내역
                filteredExpenses = expenses.filter { $0.date >= firstDayOfLastMonth && $0.date <= lastDayOfLastMonth }
            case .custom:
                var startDate = await self.startDate
                var endDate = await self.endDate
                // 직접 설정한 날짜 범위 내의 내역
                filteredExpenses = expenses.filter { $0.date >= startDate && $0.date <= endDate }
            case .all:
                // 전체 내역
                filteredExpenses = expenses
            }

            // 검색어에 따라 내역을 필터링
            if !searchText.isEmpty {
                filteredExpenses = filteredExpenses.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }

            // 선택된 정렬 순서에 따라 내역을 정렬
            let sortedExpenses: [Expense] = await {
                switch await selectedSortOrder {
                case .latestFirst:
                    // 최신 내역부터 정렬
                    return filteredExpenses.sorted { $0.date > $1.date }
                case .oldestFirst:
                    // 과거 내역부터 정렬
                    return filteredExpenses.sorted { $0.date < $1.date }
                }
            }()

            // 수입/지출에 따라 내역을 필터링
            switch await selectedTransactionType {
            case .incomeOnly:
                // 수입만 표시
                filteredExpenses = sortedExpenses.filter { $0.amount >= 0 }
            case .expenseOnly:
                // 지출만 표시
                filteredExpenses = sortedExpenses.filter { $0.amount < 0 }
            case .all:
                // 전체 내역
                filteredExpenses = sortedExpenses
            }

            // 선택된 정렬 순서에 따라 내역을 정렬하고 그룹화
            let groupedDict = Dictionary(grouping: filteredExpenses) { expenses in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: expenses.date)
                return dateComponents
            }

            // 날짜별로 정렬된 그룹을 날짜 기준으로 내림차순 정렬
            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()

                if latestFirstValue {
                    return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
                } else {
                    return calendar.compare(date2, to: date1, toGranularity: .day) == .orderedDescending
                }
            }

            await MainActor.run {
                // 화면에 표시할 그룹화된 내역을 업데이트
                groupedExpenses = sortedDict.compactMap { dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                }
                originalGroupedExpenses = groupedExpenses
            }
        }
    }

    

    func createGroupedExpenses(_ expenses: [Expense]) {
        Task {
            await updateExpenses(expenses, searchText: searchText)
        }
    }
    func deleteExpense(_ expense: Expense) {
            expenseToDelete = expense
            expenseDeleteRequest.toggle()
        }

    let category: Category

    func formatCurrency(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencySymbol = selectedCurrency
        
        if let selectedCurrency = selectedCurrency {
            // UserDefaults에서 저장된 NumberFormatter 불러오기
            if let data = UserDefaults.standard.value(forKey: "currencyFormatter") as? Data,
               let savedFormatter = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NumberFormatter {
                // 음수와 양수에 대한 형식 적용
                if selectedCurrency == "원" {
                    savedFormatter.positiveFormat = "#,##0 \(selectedCurrency)"
                    savedFormatter.negativeFormat = "- #,##0 \(selectedCurrency)"
                } else if ["د.إ", "ب.د", "د.ج", "ع.د", "د.ا", "د.ك", "ل.د", "د.م.", "ރ.", "ر.ع.", "ر.ق", "ر.س", "ل.س", "د.ت", "﷼","ج.م"].contains(selectedCurrency)
                {
                    // 특정 통화일 경우
                    formatter.currencySymbol = ""
                    Text("\(formatter.currencySymbol)")

                }
                else {
                    savedFormatter.positiveFormat = " \(selectedCurrency) #,##0.##"
                    savedFormatter.negativeFormat = "- \(selectedCurrency) #,##0.##"
                    
                }
                
                // 금액 포맷팅
                if let formattedString = savedFormatter.string(for: amount) {
                    
                    return formattedString
                }
            }
        }
        // 기본값
        return "\(amount) \(selectedCurrency ?? "")"
    }
    func sortedExpenses(for category: Category) -> [Expense]? {
        return allExpenses.filter { $0.category == category }.sorted(by: { $0.date < $1.date })
    }

    func categoryTotalAmount(category: Category) -> Double {
        let sortedExpenses = allExpenses.filter { $0.category == category }.sorted(by: { $0.date < $1.date })
        return sortedExpenses.reduce(0) { $0 + $1.amount }
    }
    func editExpense(_ expense: Expense) {
        selectedExpense = expense
        isEditingExpense.toggle()
    }
    func editCategory(_ category: Category) {
        selectedCategory = category
        isEditingCategory.toggle()
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
                       
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                deleteExpense(expense)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.delete)
                            Button {
                                editExpense(expense)
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(.edit)
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
                    if !addExpense && sortedExpenses.isEmpty {
                        HStack {
                            Spacer() 
                            Text("카테고리가 비어있습니다.")
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
                        }
                        .tint(.edit)
                    }
            }
            
        }
        .sheet(item: $selectedExpense) { expense in
            EditExpenseView(expense: expense)
                .interactiveDismissDisabled()
                .onDisappear {
                    // EditExpenseSheetView가 닫힐 때 실행되는 클로저
                    createGroupedExpenses(allExpenses)
                }
        }
        .sheet(item: $selectedCategory) { category in
            EditCategorySheetView(category: category, categoryName: $categoryName, addCategory: $addCategory)
                .interactiveDismissDisabled()
        }
        .alert("내역 삭제시 복구가 어렵습니다. 정말 삭제하시겠습니까?", isPresented: $expenseDeleteRequest) {
            Button(role: .destructive) {
                if let expenseToDelete = expenseToDelete {
                       // 내역 삭제 버튼을 눌렀을 때의 동작
                       context.delete(expenseToDelete)
                       if let index = groupedExpenses.firstIndex(where: { $0.id == category.id }) {
                           // 이 부분을 수정하여 해당 expense를 group.expenses에서 제거하도록 변경합니다.
                           groupedExpenses[index].expenses.removeAll(where: { $0.id == expenseToDelete.id })
                           if groupedExpenses[index].expenses.isEmpty {
                               // group.expenses가 비었을 때, 해당 group을 groupedExpenses에서 제거합니다.
                               groupedExpenses.remove(at: index)
                           }
                       }
                   }
            } label: {
                Text("삭제")
            }

            Button(role: .cancel) {
                expenseToDelete = nil
            } label: {
                Text("취소")
            }
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
        
    }
}

