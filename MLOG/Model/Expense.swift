//
//  Expense.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI
import SwiftData

@Model
class Expense : Identifiable {
    
    var title: String
    var amount: Double
    var date: Date

    var category: Category?
    
    
    init(title: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
    }

    @Transient
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")//로케일 설정필요
        
        
        return formatter.string(for: amount) ?? ""
    }
}
