//
//  SelectButtonView.swift
//  Malendar
//
//  Created by 최민서 on 11/12/23.
//

import SwiftUI

struct SelectButton: View {
    @Binding var isSelected: Bool
    @State var color: Color
    @State var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .frame( height: 50)
                .foregroundColor(isSelected ? color : .gray)
            Text(text)
                .foregroundColor(.white)
            
        }
    }
}

struct SelectButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectButton(isSelected: .constant(false),color: .blue, text: "Option")
    }
}
