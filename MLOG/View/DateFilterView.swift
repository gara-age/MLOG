//
//  DateFilterView.swift
//  Malendar
//
//  Created by 최민서 on 12/19/23.
//

import SwiftUI

struct DateFilterView: View {
    @State var start : Date
    @State var end : Date
    var onSubmit : ( Date , Date) -> ()
    var onClose : () -> ()
 
    
    var body: some View {
        VStack(spacing: 15){
            DatePicker(NSLocalizedString("시작 날짜", comment:""), selection: $start, displayedComponents: [.date])
                .environment(\.locale, Locale(identifier: NSLocalizedString("ko_KR", comment:"")))

            
            DatePicker(NSLocalizedString("종료 날짜", comment:""), selection: $end, displayedComponents: [.date])
                .environment(\.locale, Locale(identifier: NSLocalizedString("ko_KR", comment:"")))

            
            HStack(spacing: 15){
                Button(NSLocalizedString("취소", comment:"")) {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                Button(NSLocalizedString("적용", comment:"")) {
                    onSubmit(start, end)
                    
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.blue)
            }
            .padding(.top, 10)
        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius : 10))
        .padding(.horizontal, 30)
    }
}


