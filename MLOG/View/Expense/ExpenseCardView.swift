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
                .font(.title3.bold())
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

    private func formatCurrency(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""

        if let formattedString = formatter.string(for: amount) {
            return formattedString + "원" 
        } else {
            return "\(amount) 원"
        }
    }
}
