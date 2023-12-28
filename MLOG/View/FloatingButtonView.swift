//
//  FloatingButtonView.swift
//  Malendar
//
//  Created by 최민서 on 12/16/23.
//

import SwiftUI

struct FloatingButtonView: View {
    @Binding var addExpense: Bool
    @Binding var addCategory: Bool
    @Binding var setColor: Bool
    @Binding var setCurrency: Bool
    @Binding var isFloatingButtonClicked: Bool
    
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Menu(content: {
                            Button {
                                setCurrency.toggle()
                                isFloatingButtonClicked = false
                            }
                        label: {
                            //systemImage를 달러, 엔, 원 으로 사용자 설정값에 맞게 바뀌도록하기
                            Label("통화 설정", systemImage: "dollarsign")
                        }
                        .sheet(isPresented: $setCurrency) {
                            CurrencySettingView()
                                .interactiveDismissDisabled()
                        }
                            Button {
                                setColor.toggle()
                                isFloatingButtonClicked = false
                            }
                        label: {
                            Label("카테고리 테마 지정", systemImage: "paintpalette")
                        }
                        .sheet(isPresented: $setColor) {
                            CategoryThemeSettingView()
                                .interactiveDismissDisabled()
                        }
                            Button {
                                addCategory.toggle()
                                isFloatingButtonClicked = false

                            }
                        label: {
                            Label("카테고리 추가", systemImage: "square.grid.3x1.folder.badge.plus")
                        }
                        .sheet(isPresented: $addCategory) {
                        }
                            Button {
                                addExpense.toggle()
                                isFloatingButtonClicked = false

                            }
                        label: {
                            Label("내역 추가", systemImage: "note.text.badge.plus")
                        }
                        .sheet(isPresented: $addExpense) {
                            AddExpenseView()
                                .interactiveDismissDisabled()
                        }
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.floatingBtn)
                                .cornerRadius(30)
                                .shadow(color:Color(.floatingBtn) ,radius: 5)
                                .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0))
                            
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, 50)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            
        }
        .onTapGesture {
            isFloatingButtonClicked = true

               }
    }
    
    
}


