//
//  DateExtensions.swift
//  Malendar
//
//  Created by 최민서 on 12/20/23.
//

import SwiftUI

extension Date {
    var startOfMonth : Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return calendar.date(from: components) ?? self
    }
    var endOfMonth : Date {
        let calendar = Calendar.current
        
        return calendar.date(byAdding: .init(month: 1, minute: -1), to: self.startOfMonth) ?? self
    }
}
