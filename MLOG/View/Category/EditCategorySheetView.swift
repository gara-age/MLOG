//
//  EditCategorySheetView.swift
//  Malendar
//
//  Created by 최민서 on 12/15/23.
//

import SwiftUI
import SwiftData

struct EditCategorySheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var categoryName: String
    @Binding var addCategory: Bool
    @Environment(\.modelContext) var context
    @State private var addedCategory: Category?
    @State var inputCategoryName : String = ""
    var category: Category?
    @Query(animation: .snappy) private var allCategories: [Category]

    init(category: Category? = nil, categoryName: Binding<String>, addCategory: Binding<Bool>) {
        self.category = category
        self._categoryName = categoryName
        self._addCategory = addCategory
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(NSLocalizedString("카테고리명", comment:"")) {
                    TextField(categoryName, text: $inputCategoryName)
                        .onAppear {
                            if let category = category {
                                categoryName = category.categoryName
                            }
                        }
                }
            }
            .navigationTitle(NSLocalizedString("카테고리 수정", comment:""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(NSLocalizedString("취소", comment:"")) {
                        addCategory = false
                        categoryName = ""
                        dismiss()
                    }
                    .tint(.cancel)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString("저장", comment:"")) {
                        if let existingCategory = category {
                            existingCategory.categoryName = inputCategoryName
                        }
                        inputCategoryName = ""
                        addCategory = false
                        do {
                            try context.save()
                        } catch {
                            print("Error saving context: \(error)")
                        }
                        dismiss()
                    }
                    .disabled(inputCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || allCategories.contains(where: { $0.categoryName == inputCategoryName }))
                }
            }
        }
        .presentationDetents([.height(180)])
        .interactiveDismissDisabled()
    }
}
