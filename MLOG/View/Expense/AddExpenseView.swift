//
//  AddExpensesView.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI
import SwiftData



struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var amountString: String = ""
    @State private var category: Category?
    @State var isSoundOn: Bool = true
    @State private var isSelected = false
    @State private var isSelected2 = false
    @State private var showAlert = false
    @State private var alertText = ""
    @State private var administeredFluids = ""
    @FocusState var isInputActive: Bool
    @State private var isSelectedIncome = false
    @State private var isSelectedExpense = false
    
    
    @Query(animation: .snappy) private var allCategories: [Category]
    
    var body: some View {
        
        NavigationStack {
            List {
                if !allCategories.isEmpty{
                    HStack{
                        Text("카테고리")
                        
                        Spacer()
                        
                        Menu {
                            ForEach(allCategories) { category in
                                Button(category.categoryName){
                                    self.category = category
                                }
                            }
                            Button("None") {
                                category = nil
                            }
                        } label: {
                            if let categoryName = category?.categoryName{
                                Text(categoryName)
                            } else {
                                Text("미지정")
                            }
                        }
                        
                    }
                }
                Section("제목") {
                    TextField("지출 또는 수입 내용을 입력하세요.", text: $title)
                        .fixedSize(horizontal: false, vertical: true)
                        .focused($isInputActive)

                    
                }
                HStack{
                    SelectButton(
                        isSelected: $isSelectedIncome,
                        color: .income,
                        text: "수입")
                    .onTapGesture {
                        isSelectedIncome = true
                        if isSelectedIncome {
                            isSelectedExpense = false
                        }
                    }
                    SelectButton(
                        isSelected: $isSelectedExpense,
                        color: .expense,
                        text: "지출")
                    .onTapGesture {
                        isSelectedExpense = true
                        if isSelectedExpense {
                            isSelectedIncome = false
                        }
                    }
                }
                
                Section("금액") {
                    HStack{
                        HStack{
                            TextField("0", text: $amountString)
                                .keyboardType(.numberPad)
                                .focused($isInputActive)
                                .onChange(of: amountString, perform: { value in
                                    // 구분 기호 제거 후 숫자로 변환하여 포맷 적용
                                    let amountWithoutSeparator = value.replacingOccurrences(of: ",", with: "")
                                    amountString = formatNumberString(amountWithoutSeparator)
                                })
                            Text("원")
                                .fontWeight(.semibold)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        Button("Done") {
                                            isInputActive = false
                                        }
                                    }
                                }
                        }.multilineTextAlignment(.trailing)
                        
                    }
                    
                }
                Section("날짜") {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                .environment(\.locale, Locale(identifier: "ko_KR"))
                
                
            }
            .navigationTitle("내역 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("돌아가기"){
                        dismiss()
                    }
                    .tint(.cancel)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("추가", action: addExpense)
                        .disabled(isAddButtonDisabled)
                }
            })
        }

    }
    var isAddButtonDisabled: Bool {
        return title.isEmpty || amountString == nil || (!isSelectedIncome && !isSelectedExpense)
    }
    
    func addExpense() {
        amount = CGFloat(Double(amountString.replacingOccurrences(of: ",", with: "")) ?? 0)
        
        let amountMultiplier: Double = isSelectedIncome ? 1.0 : -1.0
        let expenses = Expense(title: title,amount: amount * amountMultiplier, date: date, category: category)
        do {
            try context.insert(expenses)
            try context.save()
            
            DispatchQueue.main.async {
                dismiss()
            }
            
        } catch {
            print("Failed to save to the CoreData: \(error)")
        }
    }
    func formatNumberString(_ string: String) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        
        if let number = formatter.number(from: string) {
            return formatter.string(from: number) ?? ""
        } else {
            return ""
        }
    }
    
}

#Preview {
    AddExpenseView()
}
