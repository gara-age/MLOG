//
//  AddCategorySheetView.swift
//  Malendar
//
//  Created by 최민서 on 12/15/23.
//

import SwiftUI
import SwiftData

struct AddCategorySheetView: View {
    @Binding var categoryName: String
    @Binding var addCategory: Bool
    @Query(animation: .snappy) private var allCategories: [Category]

    @Environment(\.modelContext) var context
    @State private var addedCategory: Category?
    @State private var addedCategories: [Category] = []
    @State private var previousCategoryColor: Color = .green
    
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(NSLocalizedString("카테고리명", comment:"")) {
                    TextField(NSLocalizedString("카테고리명을 입력해주세요.", comment:""), text: $categoryName)
                }
            }
            .navigationTitle(NSLocalizedString("새 카테고리명", comment:""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(NSLocalizedString("취소", comment:"")) {
                        addCategory = false
                        categoryName = ""
                    }
                    .tint(.cancel)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString("추가", comment:"")) {
                        
                        let category = Category(id: UUID(), categoryName: categoryName)
                        context.insert(category)
                        
                        addedCategory = category

                        categoryName = ""
                        addCategory = false


                    }
                    .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || allCategories.contains(where: { $0.categoryName == self.categoryName }))

                    .disabled(categoryName.isEmpty)
                }
            }
        }
        .presentationDetents([.height(180)])
        .interactiveDismissDisabled()
    }
    
}
