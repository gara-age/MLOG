//
//  ContentView.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var currentTab: String = "전체 내역"
    @State var addExpense: Bool = false
    @State  var addCategory: Bool = false
    @State  var setting: Bool = false
    @State var isContentReady : Bool = false
    @State private var isToolBarClicked: Bool = false
 

    var body: some View {
        
        ZStack{                

            TabView(selection: $currentTab){

                ExpensesView(currentTab: $currentTab , isToolBarClicked: $isToolBarClicked)
                    .tag("모든내역")
                    .tabItem {
                        Image(systemName: "creditcard.fill")
                        Text("모든 내역")
                    }
                
                
                CategoriesView(isToolBarClicked: $isToolBarClicked)
                    .tag("카테고리")
                    .tabItem {
                        Image(systemName: "list.clipboard.fill")
                        Text("카테고리")
                    }
            }        


            if !isContentReady {
                LottieAnimationVIew().transition(.opacity)
                    .background(Color.animBG)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
//            if isToolBarClicked {
//
//                          Color.black
//                              .opacity(0.3)
//                              .ignoresSafeArea(.all)
//                              .onTapGesture {
//                                  isToolBarClicked = false
//                              }
//                      }

        }

        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                withAnimation{isContentReady = true}
            })
        }

    }
}
    
    extension ContentView {
        var animationSplashView : some View {
            LottieAnimationVIew()
        }
    }
    


#Preview {
    ContentView()
}
