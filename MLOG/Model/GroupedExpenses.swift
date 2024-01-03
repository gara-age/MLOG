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
            return NSLocalizedString("오늘", comment:"")

        } else if calendar.isDateInYesterday(date){
            return NSLocalizedString("", comment:"")

        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: NSLocalizedString("ko_KR", comment:"")
)
            dateFormatter.dateFormat = NSLocalizedString("yyyy년 MM월 dd일", comment:"")

            
            return dateFormatter.string(from: date)        }
        
    }
}
