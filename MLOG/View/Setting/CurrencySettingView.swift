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
    
    let currencies = [
        ("🇰🇷KRW - 한국 원화", "₩"),
        ("🇯🇵JPY - 일본 엔화", "¥"),
        ("🇺🇸USD - 미국 달러", "$"),
        ("🇨🇳CNY - 중국 위안화", "元")
    ]
    //ja-JP
    //zh-Hans-CN
    //en-US
    //ko_KR
    var body: some View {
        NavigationStack {
            List {
                ForEach(currencies, id: \.0) { currency, symbol in
                    Button {
                        selectedCurrency = currency
                        print("Selected Currency: \(selectedCurrency)")
                        dismiss()
                        // 여기에서 필요한 작업 수행
                    } label: {
                        HStack {
                            Text(currency)
                            Spacer()
                            Text(symbol)
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
