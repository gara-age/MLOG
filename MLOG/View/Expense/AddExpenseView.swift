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
    //로케일 설정 필요
    @AppStorage("selectedCurrency") private var selectedCurrency: String = NSLocalizedString("원", comment:"")
    
    
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
                        Text(NSLocalizedString(NSLocalizedString("카테고리", comment:""), comment:""))
                        
                        Spacer()
                        
                        Menu {
                            ForEach(allCategories) { category in
                                Button(category.categoryName){
                                    self.category = category
                                }
                            }
                            Button(NSLocalizedString("미지정", comment:"")) {
                                category = nil
                            }
                        } label: {
                            if let categoryName = category?.categoryName{
                                Text(categoryName)
                            } else {
                                Text(NSLocalizedString("미지정", comment:""))
                            }
                        }
                        
                    }
                }
                Section(NSLocalizedString("제목", comment:"")) {
                    TextField(NSLocalizedString("지출 또는 수입 내용을 입력하세요.", comment:""), text: $title)
                        .fixedSize(horizontal: false, vertical: true)
                        .focused($isInputActive)
                    
                    
                }
                HStack{
                    SelectButton(
                        isSelected: $isSelectedIncome,
                        color: .income,
                        text: NSLocalizedString("수입", comment:""))
                    .onTapGesture {
                        isSelectedIncome = true
                        if isSelectedIncome {
                            isSelectedExpense = false
                        }
                    }
                    SelectButton(
                        isSelected: $isSelectedExpense,
                        color: .expense,
                        text: NSLocalizedString("지출", comment:""))
                    .onTapGesture {
                        isSelectedExpense = true
                        if isSelectedExpense {
                            isSelectedIncome = false
                        }
                    }
                }
                
                Section(NSLocalizedString("금액", comment:"")) {
                    HStack{
                        HStack{
                            if selectedCurrency == "원" {
                                TextField("0", text: $amountString)
                                    .keyboardType(.decimalPad)
                                    .focused($isInputActive)
                                    .onChange(of: amountString, perform: { value in
                                        // 구분 기호 제거 후 숫자로 변환하여 포맷 적용
                                        let amountWithoutSeparator = value.replacingOccurrences(of: ",", with: "")
                                        let formattedString = formatNumberString(amountWithoutSeparator)
                                        
                                        // 소수점 이후 부분에만 , 추가
                                        if value.contains(".") {
                                            let components = value.components(separatedBy: ".")
                                            if components.count == 1 {
                                                let decimalPart = components[1]
                                                
                                                // 숫자를 2자리로 제한
                                                if decimalPart.count > 2 {
                                                    let index = decimalPart.index(decimalPart.startIndex, offsetBy: 2)
                                                    amountString = formattedString + "." + decimalPart[..<index]
                                                } else {
                                                    amountString = formattedString + "." + decimalPart
                                                }
                                            }
                                        } else {
                                            amountString = formattedString
                                        }
                                        
                                        // 추가: 소수점 이하 숫자 자릿수 제한
                                        if let decimalIndex = amountString.firstIndex(of: ".") {
                                            let decimalPart = amountString.suffix(from: decimalIndex).dropFirst()
                                            if decimalPart.count > 2 {
                                                let index = decimalPart.index(decimalPart.startIndex, offsetBy: 2)
                                                amountString = amountString.prefix(upTo: decimalIndex) + "." + decimalPart.prefix(upTo: index)
                                            }
                                        }
                                    })
                                
                                
                                
                                //로케일 설정 필요
                                
                                Text(selectedCurrency)
                                    .fontWeight(.semibold)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            
                                            Button(NSLocalizedString("완료", comment:"")) {
                                                isInputActive = false
                                            }
                                        }
                                    }
                            } else {
                                Spacer(minLength: 10)
                                Text(selectedCurrency)
                                    .fontWeight(.semibold)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            
                                            Button(NSLocalizedString("완료", comment:"")) {
                                                isInputActive = false
                                            }
                                        }
                                    }
                                
                                
                                TextField("0", text: $amountString)
                                    .keyboardType(.decimalPad)
                                    .focused($isInputActive)
                                    .onChange(of: amountString, perform: { value in
                                        // 구분 기호 제거 후 숫자로 변환하여 포맷 적용
                                        let amountWithoutSeparator = value.replacingOccurrences(of: ",", with: "")
                                        let formattedString = formatNumberString(amountWithoutSeparator)
                                        
                                        // 소수점 이후 부분에만 , 추가
                                        if value.contains(".") {
                                            let components = value.components(separatedBy: ".")
                                            if components.count == 1 {
                                                let decimalPart = components[1]
                                                
                                                // 숫자를 2자리로 제한
                                                if decimalPart.count > 2 {
                                                    let index = decimalPart.index(decimalPart.startIndex, offsetBy: 2)
                                                    amountString = formattedString + "." + decimalPart[..<index]
                                                } else {
                                                    amountString = formattedString + "." + decimalPart
                                                }
                                            }
                                        } else {
                                            amountString = formattedString
                                        }
                                        
                                        // 추가: 소수점 이하 숫자 자릿수 제한
                                        if let decimalIndex = amountString.firstIndex(of: ".") {
                                            let decimalPart = amountString.suffix(from: decimalIndex).dropFirst()
                                            if decimalPart.count > 2 {
                                                let index = decimalPart.index(decimalPart.startIndex, offsetBy: 2)
                                                amountString = amountString.prefix(upTo: decimalIndex) + "." + decimalPart.prefix(upTo: index)
                                            }
                                        }
                                    })
                            }
                        }.multilineTextAlignment(.trailing)
                        
                    }
                    
                }
                Section(NSLocalizedString("날짜", comment:"")) {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                .environment(\.locale, Locale(identifier: NSLocalizedString("ko_KR", comment:"")))
                
                
            }
            .navigationTitle(NSLocalizedString("내역 추가", comment:""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(NSLocalizedString("돌아가기", comment:"")){
                        dismiss()
                    }
                    .tint(.cancel)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString("추가", comment:""), action: addExpense)
                        .disabled(isAddButtonDisabled)
                }
            })
        }
        
    }
    var isAddButtonDisabled: Bool {
        return title.isEmpty || amountString == nil || amountString == "0" || (!isSelectedIncome && !isSelectedExpense)
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
