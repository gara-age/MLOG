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
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                makeCapsule()
            }
            .lineLimit(nil)
            
            Spacer(minLength: 5)
            
            Text(formatCurrency(amount: expense.amount))
//                .font(.custom("NotoSansArabic-Medium", size: 17))
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
    //로케일 설정 필요
    func formatCurrency(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencySymbol = selectedCurrency
        
        if let selectedCurrency = selectedCurrency {
            // UserDefaults에서 저장된 NumberFormatter 불러오기
            if let data = UserDefaults.standard.value(forKey: "currencyFormatter") as? Data,
               let savedFormatter = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NumberFormatter {
                //print(selectedCurrency)
                // 음수와 양수에 대한 형식 적용
                if selectedCurrency == "원" {
                    savedFormatter.positiveFormat = "#,##0 \(selectedCurrency)"
                    savedFormatter.negativeFormat = "- #,##0 \(selectedCurrency)"
                } else if ["د.إ", "ب.د", "د.ج", "ع.د", "د.ا", "د.ك", "ل.د", "د.م.", "ރ.", "ر.ع.", "ر.ق", "ر.س", "ل.س", "د.ت", "﷼","ج.م"].contains(selectedCurrency)
                {
                    // 특정 통화일 경우
                    formatter.currencySymbol = ""
                    print(selectedCurrency)
                    Text("\(formatter.currencySymbol)")

                    // 폰트 설정 예제 (원하는 폰트와 크기로 수정)
//                    let customFont = Font.custom("NotoSansArabic-Medium", size: 17)
//                        .font(customFont)
                    
                }
                else {
                    savedFormatter.positiveFormat = " \(selectedCurrency) #,##0.##"
                    savedFormatter.negativeFormat = "- \(selectedCurrency) #,##0.##"
                    
                }
                
                // 금액 포맷팅
                if let formattedString = savedFormatter.string(for: amount) {
                    print(formattedString)
                    
                    return formattedString
                }
            }
        }
        print("\(amount) \(selectedCurrency ?? "")")
        // 기본값
        return "\(amount) \(selectedCurrency ?? "")"
    }
    
}
