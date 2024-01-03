//
//  EditExpensesView.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI
import SwiftData



struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    //로케일 설정 필요
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "$"
    
    
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
    @State private var amountString: String = ""
    @State private var inputAmountString: String = ""
    @State private var isSelected = false
    @State private var isSelected2 = false
    @State private var showAlert = false
    @State private var alertText = ""
    @State private var administeredFluids = ""
    @FocusState var isInputActive: Bool
    @State private var isSelectedIncome = false
    @State private var isSelectedExpense = false
    
    
    
    
    @Query(animation: .snappy) private var allCategories: [Category]
    
    var expense: Expense?
    
    init(expense: Expense? = nil) {
        self.expense = expense
        
        if let expense = expense {
            _title = State(initialValue: expense.title)
            _isSelectedIncome = State(initialValue: expense.amount >= 0)
            _isSelectedExpense = State(initialValue: expense.amount < 0)
            _amountString = State(initialValue: formatNumberString(String(abs(expense.amount))))
            
            _date = State(initialValue: expense.date)
            _category = State(initialValue: expense.category)
            
        }
        
    }
    
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
                            if selectedCurrency == "원" {
                                TextField(amountString, text: $inputAmountString)
                                    .keyboardType(.decimalPad)
                                    .focused($isInputActive)
                                    .onChange(of: inputAmountString, perform: { value in
                                        // 구분 기호 제거 후 숫자로 변환하여 포맷 적용
                                        let amountWithoutSeparator = value.replacingOccurrences(of: ",", with: "")
                                        let formattedString = formatNumberString(amountWithoutSeparator)
                                        
                                        if value.contains(".") {
                                            let components = value.components(separatedBy: ".")
                                            if components.count == 1 {
                                                let decimalPart = components[1]
                                                if decimalPart.count > 2 {
                                                    let index = decimalPart.index(decimalPart.startIndex, offsetBy: 2)
                                                    inputAmountString = formattedString + "." + decimalPart[..<index]
                                                } else {
                                                    inputAmountString = formattedString + "." + decimalPart
                                                }
                                            }
                                        } else {
                                            inputAmountString = formattedString
                                        }
                                        
                                        // 추가: 소수점 이하 숫자 자릿수 제한
                                        if let decimalIndex = inputAmountString.firstIndex(of: ".") {
                                            let decimalPart = inputAmountString.suffix(from: decimalIndex).dropFirst()
                                            if decimalPart.count > 2 {
                                                let index = decimalPart.index(decimalPart.startIndex, offsetBy: 2)
                                                inputAmountString = inputAmountString.prefix(upTo: decimalIndex) + "." + decimalPart.prefix(upTo: index)
                                            }
                                        }
                                    })
                                //로케일 설정 필요
                                
                                Text(selectedCurrency)
                                    .fontWeight(.semibold)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            
                                            Button("완료") {
                                                isInputActive = false
                                            }
                                        }
                                    }
                            } else {
                                Spacer(minLength: 5)
                                Text(selectedCurrency)
                                    .fontWeight(.semibold)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            
                                            Button("완료") {
                                                isInputActive = false
                                            }
                                        }
                                    }
                                
                                TextField(amountString, text: $inputAmountString)
                                    .keyboardType(.decimalPad)
                                    .focused($isInputActive)
                                    .onChange(of: inputAmountString, perform: { value in
                                        // 구분 기호 제거 후 숫자로 변환하여 포맷 적용
                                        let amountWithoutSeparator = value.replacingOccurrences(of: ",", with: "")
                                        let formattedString = formatNumberString(amountWithoutSeparator)
                                        
                                        if value.contains(".") {
                                            let components = value.components(separatedBy: ".")
                                            if components.count == 1 {
                                                let decimalPart = components[1]
                                                if decimalPart.count > 2 {
                                                    let index = decimalPart.index(decimalPart.startIndex, offsetBy: 2)
                                                    inputAmountString = formattedString + "." + decimalPart[..<index]
                                                } else {
                                                    inputAmountString = formattedString + "." + decimalPart
                                                }
                                            }
                                        } else {
                                            inputAmountString = formattedString
                                        }
                                        
                                        // 추가: 소수점 이하 숫자 자릿수 제한
                                        if let decimalIndex = inputAmountString.firstIndex(of: ".") {
                                            let decimalPart = inputAmountString.suffix(from: decimalIndex).dropFirst()
                                            if decimalPart.count > 2 {
                                                let index = decimalPart.index(decimalPart.startIndex, offsetBy: 2)
                                                inputAmountString = inputAmountString.prefix(upTo: decimalIndex) + "." + decimalPart.prefix(upTo: index)
                                            }
                                        }
                                    })
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
            
            .navigationTitle("내역 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("돌아가기"){
                        dismiss()
                    }
                    .tint(.cancel)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장", action: updateExpense)
                        .disabled(isUpdateButtonDisabled)
                }
            })
        }
    }
    
    var isUpdateButtonDisabled: Bool {
        return title.isEmpty || inputAmountString == nil || (!isSelectedIncome && !isSelectedExpense)
    }
    
    
    func updateExpense() {
        
        var updatedAmountString = inputAmountString
        if updatedAmountString.isEmpty {
            updatedAmountString = amountString
        }
        amount = CGFloat(Double(updatedAmountString.replacingOccurrences(of: ",", with: "")) ?? 0)
        
        if let existingExpense = expense {
            // expense가 존재하면 업데이트 수행
            existingExpense.title = title
            existingExpense.amount = amount * (isSelectedIncome ? 1.0 : -1.0)
            existingExpense.date = date
            existingExpense.category = category
        }
        // context 저장
        do {
            try context.save()
        } catch {
            print("Failed to save to the CoreData: \(error)")
        }
        
        // 화면 닫기
        dismiss()
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
    EditExpenseView()
}
