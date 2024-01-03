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
    @Environment(\.modelContext) var context
    @State private var addedCategory: Category?
    @State private var addedCategories: [Category] = []
    @State private var previousCategoryColor: Color = .green
    @Binding var showCategoryThemeSettingView: Bool 
    
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("카테고리명") {
                    TextField("카테고리명을 입력해주세요.", text: $categoryName)
                }
            }
            .navigationTitle("새 카테고리 이름")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        addCategory = false
                    }
                    .tint(.cancel)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("추가") {
                        
                        let category = Category(id: UUID(), categoryName: categoryName)
                        context.insert(category)
                        
                        addedCategory = category
                        categoryName = ""
                        addCategory = false
                        
                        showCategoryThemeSettingView = true
                        
                    }
                    .disabled(categoryName.isEmpty)
                }
            }
        }
        .presentationDetents([.height(180)])
        .interactiveDismissDisabled()
    }
    
}
