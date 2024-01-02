//
//  ContentView.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

struct ContentView: View {
    
    
    @State private var currentTab: String = "전체 내역"
    @State var addExpense: Bool = false
    @State  var addCategory: Bool = false
    @State  var setting: Bool = false
    @State var isContentReady : Bool = false
    @State private var isFloatingButtonClicked: Bool = false

    var body: some View {
        
        ZStack{                

            VStack{
                admob()

                TabView(selection: $currentTab){
                    
                    ExpensesView(currentTab: $currentTab, isFloatingButtonClicked: $isFloatingButtonClicked)
                        .tag("모든내역")
                        .tabItem {
                            Image(systemName: "creditcard.fill")
                            Text("모든 내역")
                        }
                    
                    
                    CategoriesView(isFloatingButtonClicked: $isFloatingButtonClicked)
                        .tag("카테고리")
                        .tabItem {
                            Image(systemName: "list.clipboard.fill")
                            Text("카테고리")
                        }
                }
            }

            if !isContentReady {
                LottieAnimationVIew().transition(.opacity)
                    .background(Color.animBG)
                    .edgesIgnoringSafeArea(.all)
            }
            if isFloatingButtonClicked {

                                     Color.black
                                         .opacity(0.3)
                                         .ignoresSafeArea(.all)
                                         .onTapGesture {
                                             isFloatingButtonClicked = false
                                         }
                                 }

        }

        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                withAnimation{isContentReady = true}
            })
        }

    }
    @ViewBuilder func admob() -> some View {
            // admob
            GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
        }
}
    
    extension ContentView {
        var animationSplashView : some View {
            LottieAnimationVIew()
        }
    }
    
struct GADBanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test Key
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
        
    }
}

#Preview {
    ContentView()
}
