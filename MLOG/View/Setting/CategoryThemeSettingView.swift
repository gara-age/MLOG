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
    @State private var showCategoryThemeSettingView = false


 
    
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
                            Button(NSLocalizedString("미지정", comment:"")) {
                                category = nil
                                settingsViewModel.setCategoryColor(nil, color: selectedCategoryColor)
                            }
                        } label: {
                            Text(settingsViewModel.newlyAddedCategoryName.isEmpty ? category?.categoryName ?? NSLocalizedString("카테고리 선택", comment:"") : settingsViewModel.newlyAddedCategoryName)
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
           
            .navigationTitle(NSLocalizedString("카테고리 테마 설정", comment:""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString("저장", comment:"")) {
                        settingsViewModel.newlyAddedCategoryName = ""
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
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
    }
}
class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel()
    @Published var categoryNames: [String] = []
    private let categoryColorKey = "categoryColor"
    @Published var showColorPicker: Bool = false
    @Published var categories: [Category] = []
    @Published var Changed = false
    @Published var newlyAddedCategoryName: String = ""
    
    private var defaultCategoryColor: Color {
            let uiColor = UIColor.random()
            return Color(uiColor)
        }
    func setNewlyAddedCategoryName(_ categoryName: String) {
            newlyAddedCategoryName = categoryName
        }
    
    @Published var color: Color = .green {
        didSet {
            UserDefaults.standard.setColor(color, forKey: "expenseCardColor")
        }
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
        if let categoryID = category?.id {
            if let storedColor = UserDefaults.standard.color(forKey: "\(categoryColorKey)_\(categoryID)") {
                return storedColor
            } else {
                // Generate and store a random color if not set yet
                let randomColor = defaultCategoryColor
                UserDefaults.standard.setColor(randomColor, forKey: "\(categoryColorKey)_\(categoryID)")
                return randomColor
            }
        } else {
            return defaultCategoryColor
        }
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
