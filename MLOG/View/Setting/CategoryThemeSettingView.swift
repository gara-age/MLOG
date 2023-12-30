//
//  CategoryThemeChangeView.swift
//  Malendar
//
//  Created by 최민서 on 12/16/23.
//

import SwiftUI
import SwiftData

struct CategoryThemeSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(animation: .snappy) private var allCategories: [Category]
    @StateObject private var settingsViewModel = SettingsViewModel.shared
    @State private var selectedCategoryColor: Color = .green
    @State private var category: Category?
    @State private var categories: [Category] = []


 
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Menu {
                            ForEach(allCategories) { category in
                                Button(category.categoryName) {
                                    self.category = category
                                    selectedCategoryColor = settingsViewModel.getCategoryColor(category)
                                    settingsViewModel.setCategoryColor(category, color: selectedCategoryColor)
                                }
                                .lineLimit(1)
                                
                            }
                            Button("미선택") {
                                category = nil
                                settingsViewModel.setCategoryColor(nil, color: selectedCategoryColor)
                            }
                        } label: {
                            Text(category?.categoryName ?? "카테고리 선택")
                        }
                        
                        ColorPicker("", selection: $selectedCategoryColor)
                            .onChange(of: selectedCategoryColor) { _ in
                                settingsViewModel.setCategoryColor(category, color: selectedCategoryColor)
                            }
                            .onChange(of: settingsViewModel.showColorPicker) { showColorPicker in
                                if !showColorPicker {
                                    settingsViewModel.showColorPicker = false
                                }
                            }
                    }
                }
            }
            .navigationTitle("카테고리 테마 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") {
                        dismiss()
                    }
                }


            }
        }
        .onChange(of: allCategories) { updatedCategories in
            settingsViewModel.categoryNames = updatedCategories.map { $0.categoryName }
            categories = updatedCategories
        }
        .presentationDetents([.height(180)])
    }
}

class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel()
    @Published var categoryNames: [String] = []
    private let categoryColorKey = "categoryColor"
    @Published var showColorPicker: Bool = false
    @Published var categories: [Category] = []
    @Published var Changed = false

    
    
    @Published var color: Color = .green {
        didSet {
            UserDefaults.standard.setColor(color, forKey: "expenseCardColor")
        }
    }
    
    init() {
        self.color = UserDefaults.standard.color(forKey: "expenseCardColor") ?? .green
    }
    
    
    func setCategoryColor(_ category: Category?, color: Color) {
            if let categoryID = category?.id {
                UserDefaults.standard.setColor(color, forKey: "\(categoryColorKey)_\(categoryID)")
            } else {
                UserDefaults.standard.setColor(color, forKey: categoryColorKey)
            }
            setColor(color)
            updateChanged()
        }

        func getCategoryColor(_ category: Category?) -> Color {
            if let categoryID = category?.id,
               let storedColor = UserDefaults.standard.color(forKey: "\(categoryColorKey)_\(categoryID)") {
                return storedColor
            }
            return color
        }
    
    func setColor(_ newColor: Color) {
        color = newColor
        updateChanged()
        objectWillChange.send()
    }
    private func updateChanged() {
           Changed.toggle()
       }
    
    
}


extension UserDefaults {
    func setColor(_ color: Color, forKey key: String) {
        let uiColor = UIColor(color)
        let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
        set(data, forKey: key)
    }
    
    func color(forKey key: String) -> Color? {
        guard let data = data(forKey: key),
              let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor else {
            return nil
        }
        return Color(uiColor)
    }
}


#Preview {
    CategoryThemeSettingView()
}
