//
//  ExpenseCardView.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct ExpenseCardView: View {
    @Bindable var expense: Expense
    @AppStorage("selectedCurrency") private var selectedCurrency: String?
    
    var displayTag: Bool = true
    @State private var color: Color = .green
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    //로케일 설정 필요
    @State private var emptyCurrency : String = "$"
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                makeCapsule()
            }
            .lineLimit(nil)
            
            Spacer(minLength: 5)
            
            Text(formatCurrency(amount: expense.amount))
        }
        .onAppear {
            color = settingsViewModel.color
        }
        .onChange(of: color) { _ in
        }
        .onChange(of: settingsViewModel.Changed) { newValue in
            settingsViewModel.Changed = newValue
        }
    }
    
    @ViewBuilder
    private func makeCapsule() -> some View {
        if let categoryName = expense.category?.categoryName, displayTag {
            let categoryColor = settingsViewModel.getCategoryColor(expense.category)
            
            Text(categoryName)
                .font(.caption2)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(categoryColor, in: .capsule)
            
        }
    }
    //로컬라이즈 시에 .onapear로 기본 통화 처리필요 (한,일,중,미 외에는 달러로 처리 되도록)
    func formatCurrency(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        //첫 실행시를 위해 기본 통화 처리 로컬라이징 처리하여서 국가별 다르게하면 될듯
        guard let selectedCurrency = selectedCurrency, !selectedCurrency.isEmpty else {
            // If selectedCurrency is empty, provide a default currency
            let formattedAmount = formatter.string(for: amount) ?? ""
            
            if amount >= 0 {
                if emptyCurrency == "원"{
                    return "\(formattedAmount) \(emptyCurrency)"
                }
                else{
                    return "\(emptyCurrency) \(formattedAmount)"
                }
            } else {
                if emptyCurrency == "원"{
                    return "\(formattedAmount) \(emptyCurrency)"
                }
                return "- \(emptyCurrency) \(expense.amount*(-1))"
            }
        }

            
        formatter.currencySymbol = selectedCurrency
        
            // UserDefaults에서 저장된 NumberFormatter 불러오기
            if let data = UserDefaults.standard.value(forKey: "currencyFormatter") as? Data,
               let savedFormatter = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NumberFormatter {
                // 음수와 양수에 대한 형식 적용
                if selectedCurrency == "원" {
                    savedFormatter.positiveFormat = "#,##0.## \(selectedCurrency)"
                    savedFormatter.negativeFormat = "- #,##0.## \(selectedCurrency)"
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
        
        // 기본값
        return "\(amount) \(selectedCurrency ?? "")"
    }
    
}
