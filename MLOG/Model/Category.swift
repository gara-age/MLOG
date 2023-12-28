//
//  Category.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI
import SwiftData

@Model
class Category{
    var id: UUID
    var categoryName: String

    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    
    init(id: UUID = UUID(), categoryName: String) {
           self.id = UUID()
           self.categoryName = categoryName
       }
    
}
