
//
//  ExpensesView.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Binding var currentTab: String
    
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) var allExpenses: [Expense]
    @Environment(\.modelContext)  var context
    @StateObject private var settingsViewModel = SettingsViewModel.shared
    
    @State  var groupedExpenses: [GroupedExpenses] = []
    @State  var originalGroupedExpenses: [GroupedExpenses] = []
    @State var addExpense: Bool = false
    @State  var addCategory: Bool = false
    @State private var isEditingExpense = false
    @State  var searchText: String = ""
    
    @State  var categoryName: String = ""
    @State private var addedCategory: Category?
    @State private var selectedExpense: Expense?
    @State private var setCurrency: Bool = false
    @State private var deleteRequest: Bool = false
    
    //검색기능
    @State private var selectedDateFilter: DateFilter = .all
    @State private var selectedSortOrder: SortOrder = .latestFirst
    @State private var selectedTransactionType: TransactionTypeFilter = .all
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var latestFirst : Bool = true
    @State private var oldestFirst : Bool = false
    @State private var customDate : String = NSLocalizedString("직접 설정", comment:"")

    @State private var showFilterView : Bool = false
    @State private var filteredExpenses: [GroupedExpenses] = []
    @State private var isSearching = false
    @State private var selectedExpenseForDeletion: Expense?
    @State private var showCategoryThemeSettingView = false
    
    @Binding var isFloatingButtonClicked: Bool
    
    struct LocalizableStrings {
        static let all  = NSLocalizedString("전체 내역", comment: "")
        static let oneMonth  = NSLocalizedString("1개월", comment: "")
        static let threeMonths  = NSLocalizedString("3개월", comment: "")
        static let lastMonth  = NSLocalizedString("지난달", comment: "")
        static let custom  = NSLocalizedString("직접 설정", comment: "")
        
        static let latestFirst  = NSLocalizedString("최신순", comment: "")
        static let oldestFirst  = NSLocalizedString("과거순", comment: "")

        static let alldetails  = NSLocalizedString("전체", comment: "")
        static let income = NSLocalizedString("수입만", comment: "")
        static let expense  = NSLocalizedString("지출만", comment: "")


    }

    enum DateFilter: String, CaseIterable {
        
        case all = "전체 내역"
        case oneMonth = "1개월"
        case threeMonths = "3개월"
        case lastMonth = "지난달"
        case custom = "직접 설정"
        
        var description : String {
                get {
                    switch(self) {
                    case .all:
                        return LocalizableStrings.all
                    case .oneMonth:
                        return LocalizableStrings.oneMonth
                    case .threeMonths:
                        return LocalizableStrings.threeMonths
                    case .lastMonth:
                        return LocalizableStrings.lastMonth
                    case .custom:
                        return LocalizableStrings.custom
                    }
                }
            }
        
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
        
        var description : String {
                get {
                    switch(self) {
                    case .latestFirst:
                        return LocalizableStrings.latestFirst
                    case .oldestFirst:
                        return LocalizableStrings.oldestFirst
                    }
                }
            }
        
        static var defaultSortOrder: SortOrder = .latestFirst
        
    }
    
    enum TransactionTypeFilter: String, CaseIterable {
        case all = "전체"
        case incomeOnly = "수입만"
        case expenseOnly = "지출만"
        
        var description : String {
                get {
                    switch(self) {
                    case .all:
                        return LocalizableStrings.alldetails
                    case .incomeOnly:
                        return LocalizableStrings.income
                    case .expenseOnly:
                        return LocalizableStrings.expense
                    }
                }
            }
    }
    
    
    
    var body: some View {
        
        ZStack{
            NavigationStack {
                menuView()
                expensesListView()
                    .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: Text(NSLocalizedString("검색", comment:"")
))
                    .navigationTitle(NSLocalizedString("지출 내역", comment:"")
)
                    .navigationBarTitleDisplayMode(.inline)
                    .overlay{
                        if allExpenses.isEmpty || groupedExpenses.isEmpty {
                            ContentUnavailableView{
                                Label(NSLocalizedString("내역이 없습니다", comment:"")
, systemImage: "tray.fill")
                            }
                        }
                    }
                    .blur(radius: showFilterView ? 8 : 0)
                    .disabled(showFilterView)
                    .overlay{
                        ZStack{
                            if showFilterView {
                                DateFilterView(start: startDate, end: endDate, onSubmit:{ start , end in
                                    startDate = start
                                    endDate = end
                                    filterExpenses(searchText)
                                    showFilterView = false
                                    selectedDateFilter = .custom
                                    
                                    
                                }, onClose: {
                                    showFilterView = false
                                })
                                .transition(.opacity)
                            }
                        }
                        .animation(.snappy, value: showFilterView)
                    }
                
                
                
            }
            FloatingButtonView(addExpense: $addExpense, addCategory: $addCategory, showCategoryThemeSettingView : $showCategoryThemeSettingView, setCurrency: $setCurrency, isFloatingButtonClicked: $isFloatingButtonClicked)
            
        }
        
        .onAppear {
            createGroupedExpenses(allExpenses)
        }
        .onChange(of: settingsViewModel.Changed) { newValue in
            settingsViewModel.Changed = newValue
            createGroupedExpenses(allExpenses)
            
        }
        .onChange(of: allExpenses, perform: { newValue in
            if newValue.count > allExpenses.count || groupedExpenses.isEmpty || currentTab == "Categories" {
                createGroupedExpenses(newValue)
            }
        })
        
        .onChange(of: allExpenses, initial: true) {
            oldValue, newValue in
            if newValue.count > oldValue.count || groupedExpenses.isEmpty || currentTab ==  "Categories"{
                createGroupedExpenses(newValue)
            }
            settingsViewModel.Changed.toggle()
            saveContext()
        }
        
        .onChange(of: searchText) { newValue in
            
            filterExpenses(newValue)
        }
        .onChange(of: isSearching) { newValue in
            if !newValue {
                // 취소 버튼이 눌렸을 때, 검색어를 초기화하고 원래 데이터로 복원
                searchText = ""
                groupedExpenses = originalGroupedExpenses
            }
        }
        .sheet(isPresented: $addExpense) {
            AddExpenseView()
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $showCategoryThemeSettingView) {
            CategoryThemeSettingView()
                .interactiveDismissDisabled()
        }
        .sheet(item: $selectedExpense) { expense in
            EditExpenseView(expense: expense)
                .interactiveDismissDisabled()
                .onDisappear {
                    // EditExpenseSheetView가 닫힐 때 실행되는 클로저
                    createGroupedExpenses(allExpenses)
                }
        }
        .sheet(isPresented: $addCategory) {
            AddCategorySheetView(
                categoryName: $categoryName,
                addCategory: $addCategory,
                showCategoryThemeSettingView: $showCategoryThemeSettingView
            )
            .interactiveDismissDisabled()
        }
        
        .sheet(isPresented: $setCurrency) {
            CurrencySettingView()
                .interactiveDismissDisabled()
        }
        
    }
    
    func filterExpenses(_ searchText: String) {
        Task {
            await updateExpenses(allExpenses, searchText: searchText.isEmpty ? "" : searchText)
        }
    }
    
    func createGroupedExpenses(_ expenses: [Expense]) {
        Task {
            await updateExpenses(expenses, searchText: searchText)
        }
    }
    
    private func expensesListView() -> some View {
        List {
            ForEach($groupedExpenses) { $group in
                Section(group.groupTitle) {
                    ForEach(group.expenses.sorted(by: { (expense1, expense2) -> Bool in
                        switch selectedSortOrder {
                        case .latestFirst:
                            return expense1.date > expense2.date
                        case .oldestFirst:
                            return expense1.date < expense2.date
                        }
                    })) { expense in
                        
                        ExpenseCardView(expense: expense)
                            .environmentObject(settingsViewModel)
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    selectedExpenseForDeletion = expense
                                    deleteRequest.toggle()
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
                    }
                }
            }
            .environment(\.locale, Locale(identifier: NSLocalizedString("ko_KR", comment:"")
))
        }
        
        .alert(NSLocalizedString("내역 삭제시 복구가 어렵습니다. 정말 삭제하시겠습니까?", comment:"")
, isPresented: $deleteRequest) {
            Button(role: .destructive) {
                if let expenseToDelete = selectedExpenseForDeletion {
                    context.delete(expenseToDelete)
                    withAnimation {
                        groupedExpenses.removeAll { $0.expenses.contains(expenseToDelete) }
                        if let index = originalGroupedExpenses.firstIndex(where: { $0.expenses.contains(expenseToDelete) }) {
                            originalGroupedExpenses[index].expenses.removeAll { $0 == expenseToDelete }
                            if originalGroupedExpenses[index].expenses.isEmpty {
                                originalGroupedExpenses.remove(at: index)
                            }
                        }
                    }
                }
            } label: {
                Text(NSLocalizedString("삭제", comment:"")
)
            }
            
            Button(role: .cancel) {
                selectedExpenseForDeletion = nil
            } label: {
                Text(NSLocalizedString("취소", comment:""))
            }
        }
        
        
    }
    
    private func resetFiler() {
        selectedDateFilter = .all
        selectedSortOrder = .latestFirst
        selectedTransactionType = .all
        searchText = ""
        filterExpenses("")
        latestFirst = true
    }
    private func menuView() -> some View {
        HStack(spacing:25){
            //날짜 버튼
            Menu{
                Button(NSLocalizedString("1개월", comment:"")){
                    selectedDateFilter = .oneMonth
                    filterExpenses(searchText)
                }
                Button(NSLocalizedString("3개월", comment:"")){
                    selectedDateFilter = .threeMonths
                    filterExpenses(searchText)
                }
                Button(NSLocalizedString("지난달", comment:"")){
                    selectedDateFilter = .lastMonth
                    filterExpenses(searchText)
                }
                Button(customDate){
                    showFilterView.toggle()
                    
                }
                Button(NSLocalizedString("전체 내역", comment:"")){
                    selectedDateFilter = .all
                    filterExpenses(searchText)
                }
                
                
            } label: {
                Text("\(selectedDateFilter.description)")
            }
            
            Divider().frame(height: 10)
            
            Menu{
                //시간순 정렬 버튼
                Button(NSLocalizedString("최신순", comment:"")
){
                    selectedSortOrder = .latestFirst
                    filterExpenses(searchText)
                    latestFirst = true
                }
                Button(NSLocalizedString("과거순", comment:"")
){
                    selectedSortOrder = .oldestFirst
                    filterExpenses(searchText)
                    latestFirst = false
                    
                }
            } label: {
                Text("\(selectedSortOrder.description)")
            }
            
            Divider().frame(height: 10)
            
            Menu{
                //수입지출 선택 버튼
                Button(NSLocalizedString("전체", comment:"")
){
                    selectedTransactionType = .all
                    filterExpenses(searchText)
                }
                Button(NSLocalizedString("수입만", comment:"")
){
                    selectedTransactionType = .incomeOnly
                    filterExpenses(searchText)
                }
                Button(NSLocalizedString("지출만", comment:"")
){selectedTransactionType = .expenseOnly
                    filterExpenses(searchText)
                }
            } label: {
                Text("\(selectedTransactionType.description)")
            }
            
            Divider().frame(height: 10)
            
            Button(NSLocalizedString("초기화", comment:"")
){
                resetFiler()
            }
            .tint(.red)
            
        }
        
    }
    
    func editExpense(_ expense: Expense) {
        selectedExpense = expense
        isEditingExpense.toggle()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
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
    
}



#Preview {
    ContentView()
}
