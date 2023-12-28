//
//  GroupedExpense.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI

struct GroupedExpenses: Identifiable {
    var id: UUID = .init()
    var date: Date
    var expenses: [Expense]
    

    var groupTitle: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date){
            return "오늘"
        } else if calendar.isDateInYesterday(date){
            return "어제"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 "
            
            return dateFormatter.string(from: date)        }
        
    }
}
