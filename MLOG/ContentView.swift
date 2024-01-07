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
    
    
    @State private var currentTab: String = NSLocalizedString("모든 내역", comment:"")
    @State var addExpense: Bool = false
    @State  var addCategory: Bool = false
    @State  var setting: Bool = false
    @State var isContentReady : Bool = false
    @State private var isFloatingButtonClicked: Bool = false
    @State private var tagForExpense : String = NSLocalizedString("모든 내역", comment:"")
    @State private var tagForCategory : String = NSLocalizedString("카테고리", comment:"")
    @State var korea : Bool = false
    @State var english : Bool = false
    @State var chinaEasy : Bool = false
    @State var chinaHard : Bool = false
    @State var japan : Bool = false

    
    var body: some View {
        
        ZStack{
            
            VStack{
                admob()
                
                TabView(selection: $currentTab){
                    
                    ExpensesView(currentTab: $currentTab, isFloatingButtonClicked: $isFloatingButtonClicked)
                        .tag(NSLocalizedString(tagForExpense, comment:""))
                        .tabItem {
                            Image(systemName: "creditcard.fill")
                            Text(NSLocalizedString("모든 내역", comment:""))
                        }
                    
                    
                    CategoriesView(isFloatingButtonClicked: $isFloatingButtonClicked)
                        .tag(NSLocalizedString(tagForCategory, comment:""))
                        .tabItem {
                            Image(systemName: "list.clipboard.fill")
                            Text(NSLocalizedString("카테고리", comment:""))
                        }
                }
            }
            
            if !isContentReady {
                LottieAnimationVIew()
                    .transition(.opacity)
                    .background(Color.animBG)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear {
                        // LottieAnimationVIew가 사라질 때, 처음 실행 여부를 확인하고 CurrencySettingView를 표시
                        if !UserDefaults.standard.bool(forKey: "isAppAlreadyLaunchedOnce") {
                            UserDefaults.standard.set(false, forKey: "isAppAlreadyLaunchedOnce")
                            if tagForExpense == "모든 내역" {
                                korea.toggle()
                            } else if tagForExpense == "All details" {
                                english.toggle()
                            } else if tagForExpense == "すべての詳細" {
                                japan.toggle()
                            } else if tagForExpense == "所有明细" {
                                chinaEasy.toggle() //중국어 간체
                            } else if tagForExpense == "所有明細" {
                                chinaHard.toggle() //중국어 번체
                            }
                        }
                    }
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
//        //AddExpenseView -> 튜토리얼 화면 띄울 부분 , 실제로는 튜토리얼을 통화 설정 위에 overlay로 띄우는게 나을듯
//        .sheet(isPresented: $korea) {
//            AddExpenseView()
//                .onDisappear {
//                    // LottieAnimationVIew가 사라질 때, 처음 실행 여부를 확인하고 CurrencySettingView를 표시
//                    if !UserDefaults.standard.bool(forKey: "isAppAlreadyLaunchedOnce") {
//                        UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
//                        setting = true
//                    }
//                }
//        }
    
        //앱을 처음 실행할때만 통화설정 창 열림
        .sheet(isPresented: $setting) {
            CurrencySettingView()
            .interactiveDismissDisabled()
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
