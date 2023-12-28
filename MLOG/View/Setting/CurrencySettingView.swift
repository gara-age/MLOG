//
//  CurrencySettingsView.swift
//  Malendar
//
//  Created by 최민서 on 11/22/23.
//

import SwiftUI

struct CurrencySettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var selectedCurrency: String?
    
    struct Currency: Identifiable {
        var id: String { name }
        let name: String
    }

    let currencies: [Currency] = [
        Currency(name: "🇰🇷KRW 한국 원화"),    //ko_KR
        Currency(name: "🇯🇵JPY 일본 엔화"),    //ja-JP
        Currency(name: "🇺🇸USD 미국 달러"),    //en-US
        Currency(name: "🇨🇳CNY 중국 위안화")    //zh-Hans-CN
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(currencies) { currency in
                    Button {
                        selectedCurrency = currency.name
                        print("Selected Currency: \(selectedCurrency)")
                        dismiss()
                        // 여기에서 필요한 작업 수행
                    } label: {
                        HStack {
                            Text("\(currency.name)")
                        }
                        .contentShape(Rectangle())
                    }
                }
                
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("검색"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("통화 설정")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                    .tint(.cancel)
                }
            }
        }
    }
}

#Preview {
    CurrencySettingView()
}
