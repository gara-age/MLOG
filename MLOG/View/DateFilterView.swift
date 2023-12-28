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
            DatePicker("Start Date", selection: $start, displayedComponents: [.date])
                .environment(\.locale, Locale(identifier: "ko_KR"))

            
            DatePicker("End Date", selection: $end, displayedComponents: [.date])
                .environment(\.locale, Locale(identifier: "ko_KR"))

            
            HStack(spacing: 15){
                Button("Cancel") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                Button("Filter") {
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


