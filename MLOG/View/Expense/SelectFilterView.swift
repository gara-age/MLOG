//
//  SelectFilterView.swift
//  Malendar
//
//  Created by 최민서 on 12/20/23.
//

import SwiftUI

struct SelectFilterView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectOneMonth = false
    @State private var selectThreeMonth = false
    @State private var selectLastMonth = false
    @State private var selectCustom = false
    @State private var selectAllDate = false
    @State private var selectLatestFirst = false
    @State private var selectOldestFirst = false
    @State private var selectAll = false
    @State private var selectIncome = false
    @State private var selectExpense = false
    @State private var selectBasic = false
    @State private var selectLowValue = false
    @State private var selectHighValue = false
    
    



    
    var body: some View {
        DisclosureGroup{

            VStack(spacing: 15){
                Text("검색 기간 설정")
                
                HStack(){
                    //1개월, 3개월, 지난달, 직접설정, 전체내역
                    SelectButton(
                        isSelected: $selectOneMonth,
                        color: .income,
                        text: "1개월")
                    .onTapGesture {
                        selectOneMonth = true
                        if selectOneMonth {
                            selectThreeMonth = false
                            selectLastMonth = false
                            selectCustom = false
                            selectAllDate = false
                            
                        }
                    }
                    SelectButton(
                        isSelected: $selectThreeMonth,
                        color: .income,
                        text: "3개월")
                    .onTapGesture {
                        selectThreeMonth = true
                        if selectThreeMonth {
                            selectOneMonth = false
                            selectLastMonth = false
                            selectCustom = false
                            selectAllDate = false
                            
                        }
                    }
                    SelectButton(
                        isSelected: $selectLastMonth,
                        color: .income,
                        text: "지난달")
                    .onTapGesture {
                        selectLastMonth = true
                        if selectLastMonth {
                            selectOneMonth = false
                            selectThreeMonth = false
                            selectCustom = false
                            selectAllDate = false
                            
                        }
                    }
                    SelectButton(
                        isSelected: $selectCustom,
                        color: .income,
                        text: "직접설정")
                    .onTapGesture {
                        selectCustom = true
                        if selectCustom {
                            selectOneMonth = false
                            selectThreeMonth = false
                            selectLastMonth = false
                            selectAllDate = false
                            
                        }
                    }
                    SelectButton(
                        isSelected: $selectAllDate,
                        color: .income,
                        text: "전체 기간")
                    .onTapGesture {
                        selectAllDate = true
                        if selectAllDate {
                            selectOneMonth = false
                            selectThreeMonth = false
                            selectLastMonth = false
                            selectCustom = false
                            
                        }
                    }
                }
                Text("정렬 설정")
                HStack{
                    //최신순, 과거순
                    SelectButton(
                        isSelected: $selectLatestFirst,
                        color: .income,
                        text: "최신순")
                    .onTapGesture {
                        selectLatestFirst = true
                        if selectLatestFirst {
                            selectOldestFirst = false
                        }
                    }
                    SelectButton(
                        isSelected: $selectOldestFirst,
                        color: .income,
                        text: "과거순")
                    .onTapGesture {
                        selectOldestFirst = true
                        if selectOldestFirst {
                            selectLatestFirst = false
                        }
                    }
                }
                HStack{
                    //전체 , 수입,  지출
                    SelectButton(
                        isSelected: $selectAll,
                        color: .income,
                        text: "전체내역")
                    .onTapGesture {
                        selectAll = true
                        if selectAll {
                            selectExpense = false
                            selectIncome = false
                        }
                    }
                    SelectButton(
                        isSelected: $selectExpense,
                        color: .income,
                        text: "소비만")
                    .onTapGesture {
                        selectExpense = true
                        if selectExpense {
                            selectIncome = false
                            selectAll = false
                        }
                    }
                    SelectButton(
                        isSelected: $selectIncome,
                        color: .income,
                        text: "수입만")
                    .onTapGesture {
                        selectIncome = true
                        if selectIncome {
                            selectExpense = false
                            selectAll = false
                        }
                    }
                }
                HStack{
                    //기본순, 적은금액순, 큰금액순
                    SelectButton(
                        isSelected: $selectBasic,
                        color: .income,
                        text: "기본순")
                    .onTapGesture {
                        selectBasic = true
                        if selectBasic {
                            selectLowValue = false
                            selectHighValue = false
                            
                        }
                    }
                    SelectButton(
                        isSelected: $selectLowValue,
                        color: .income,
                        text: "적은 금액순")
                    .onTapGesture {
                        selectLowValue = true
                        if selectLowValue {
                            selectBasic = false
                            selectHighValue = false
                            
                        }
                    }
                    SelectButton(
                        isSelected: $selectHighValue,
                        color: .income,
                        text: "큰 금액순")
                    .onTapGesture {
                        selectHighValue = true
                        if selectHighValue {
                            selectBasic = false
                            selectLowValue = false
                            
                        }
                    }
                }
                HStack(spacing: 15){
                    Button("Cancel") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 5))
                    .tint(.red)
                    
                    Button("Filter") {
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 5))
                    .tint(.blue)
                }
                .padding(.top, 10)
                
            }
            .padding(10)
            .background(.bar, in: .rect(cornerRadius : 10))
            
        } label: {
            Spacer()
            Text("검색 필터 설정")

        }
    }
}

#Preview {
    SelectFilterView()
}
