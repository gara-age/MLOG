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
    @AppStorage("selectedCurrency") private var selectedCurrency: String = ""
    //로컬라이즈 시에 .onapear로 기본 통화 처리필요 (한,일,중,미 외에는 달러로 처리 되도록)
    @AppStorage("selectedCurrencyID") private var selectedCurrencyID: String = NSLocalizedString("원🇰🇷KRW   대한민국   -   원", comment:"")
    @State private var selectedCurrencyName: String = ""
    @AppStorage("currencySelect") private var currencySelect : Bool?

    struct Currency: Identifiable {
        var id: String { symbol + name }
        let symbol: String
        let name: String
    }
    
    let currencies: [Currency] = [
        
        Currency(symbol: "د.إ", name: NSLocalizedString("🇦🇪AED   아랍에미리트   -   디르함", comment:"")
),
        Currency(symbol: "؋", name: NSLocalizedString("🇦🇫AFN   아프카니스탄   -   아프가니", comment:"")),
        Currency(symbol: "L", name: NSLocalizedString("🇦🇱ALL   알바니아   -   렉", comment:"")),
        Currency(symbol: "Դ", name: NSLocalizedString("🇦🇲AMD   아르메니아   -   드람", comment:"")),
        Currency(symbol: "Kz", name: NSLocalizedString("🇦🇴AOA   앙골라   -   콴자", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇦🇷ARS   아르헨티나   -   페소", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇦🇺AUD   오스트레일리아   -   달러", comment:"")),
        Currency(symbol: "ƒ", name: NSLocalizedString("🇦🇼AWG   아루바   -   플로린", comment:"")),
        Currency(symbol: "ман", name: NSLocalizedString("🇦🇿AZN   아제르바이잔   -   마나트", comment:"")),
        Currency(symbol: "КМ", name: NSLocalizedString("🇧🇦BAM   보스니아 헤르체코비나   -   마커", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇧🇧BBD   바베이도스   -   달러", comment:"")),
        Currency(symbol: "৳", name: NSLocalizedString("🇧🇩BDT   방글라데시   -   타카", comment:"")),
        Currency(symbol: "лв", name: NSLocalizedString("🇧🇬BGN   불가리아   -   불가리안 레프", comment:"")),
        Currency(symbol: "ب.د", name: NSLocalizedString("🇧🇭BHD   바레인   -   디나르", comment:"")),
        Currency(symbol: "₣", name: NSLocalizedString("🇧🇮BIF   브룬디   -   프랑", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇧🇲BMD   버뮤다   -   버뮤디안 달러", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇧🇳BND   브루나이   -   달러", comment:"")),
        Currency(symbol: "Bs", name: NSLocalizedString("🇧🇴BOB   볼리비아   -   볼리비아노", comment:"")),
        Currency(symbol: "R$", name: NSLocalizedString("🇧🇷BRL   브라질   -   브라질리안 헤알", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇧🇸BSD   바하마   -   바하미안 달러", comment:"")),
        Currency(symbol: "Nu", name: NSLocalizedString("🇧🇹BTN   부탄   -   눌트럼", comment:"")),
        Currency(symbol: "P", name: NSLocalizedString("🇧🇼BWP   보츠와나   -   풀라", comment:"")),
        Currency(symbol: "Br", name: NSLocalizedString("🇧🇾BYR   벨라루스   -   벨라루시안 루블", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇧🇿BZD   벨리즈   -   달러", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇨🇦CAD   캐나다   -   캐나다달러", comment:"")),
        Currency(symbol: "₣", name: NSLocalizedString("🇨🇩CDF   콩고 킨샤사   -   프랑", comment:"")),
        Currency(symbol: "₣", name: NSLocalizedString("🇨🇭CHF   스위스   -   프랑", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇨🇱CLP   칠레   -   칠레니아 페소", comment:"")),
        Currency(symbol: "¥", name: NSLocalizedString("🇨🇳CNY   중국   -   위안", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇨🇴COP   콜롬비아   -   콜롬비안 페소", comment:"")),
        Currency(symbol: "₡", name: NSLocalizedString("🇨🇷CRC   코스타리카   -   코스타리칸 콜론", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇨🇺CUP   쿠바   -   쿠반 페소", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇨🇻CVE   카보 베르데   -   카보 베르데 에스쿠도", comment:"")),
        Currency(symbol: "Kč", name: NSLocalizedString("🇨🇿CZK   체코 공화국   -   체코 코루나", comment:"")),
        Currency(symbol: "₣", name: NSLocalizedString("🇩🇯DJF   지부티   -   지부티 프랑", comment:"")),
        Currency(symbol: "kr", name: NSLocalizedString("🇩🇰DKK   덴마크   -   덴마크 크로네", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇩🇴DOP   도미니카 공화국   -   도미니카 페소", comment:"")),
        Currency(symbol: "د.ج", name: NSLocalizedString("🇩🇿DZD   알제리   -   알제르 디나르", comment:"")),
        Currency(symbol: "ج.م" , name: NSLocalizedString("🇪🇬EGP   이집트   -   이집트 파운드", comment:"")),
        Currency(symbol: "Nfk", name: NSLocalizedString("🇪🇷ERN   에리트레아   -   낙파", comment:"")),
        Currency(symbol: "Br", name: NSLocalizedString("🇪🇹ETB   에티오피아   -   에디오피안 비르", comment:"")),
        Currency(symbol: "€", name: NSLocalizedString("🇪🇺EUR   유로", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇫🇯FJD   피지   -   피지 달러", comment:"")),
        Currency(symbol: "£", name: NSLocalizedString("🇫🇰FKP   포크랜드 제도   -   포크랜드 제도 파운드", comment:"")),
        Currency(symbol: "£", name: NSLocalizedString("🇬🇧GBP   영국   -   파운드", comment:"")),
        Currency(symbol: "ლ", name: NSLocalizedString("🇬🇪GEL   조지아   -   조지아 라리", comment:"")),
        Currency(symbol: "₵", name: NSLocalizedString("🇬🇭GHS   가나   -   가나 세디", comment:"")),
        Currency(symbol: "£", name: NSLocalizedString("🇬🇮GIP   지브롤터   -   지브롤터 파운드", comment:"")),
        Currency(symbol: "D", name: NSLocalizedString("🇿🇲GMD   잠비아   -   달라시", comment:"")),
        Currency(symbol: "₣", name: NSLocalizedString("🇬🇳GNF   기니아   -   기니아 프랑", comment:"")),
        Currency(symbol: "Q", name: NSLocalizedString("🇬🇹GTQ   과테말라   -   케트살", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇬🇾GYD   가이아나   -   가이아나 달러", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇭🇰HKD   홍콩   -   홍콩달러", comment:"")),
        Currency(symbol: "L", name: NSLocalizedString("🇭🇳HNL   온두라스   -   렘피라", comment:"")),
        Currency(symbol: "G", name: NSLocalizedString("🇭🇹HTG   아이티   -   아이티 구르드", comment:"")),
        Currency(symbol: "Ft", name: NSLocalizedString("🇭🇺HUF   헝가리   -   헝가리 포린트", comment:"")),
        Currency(symbol: "Rp", name: NSLocalizedString("🇮🇩IDR   인도네시아   -   인도네시아 루피아", comment:"")),
        Currency(symbol: "₪", name: NSLocalizedString("🇮🇱ILS   이스라엘   -   이스라엘 신 셰켈", comment:"")),
        Currency(symbol: "₹", name: NSLocalizedString("🇮🇳INR   인도   -   인도 루피", comment:"")),
        Currency(symbol: "ع.د", name: NSLocalizedString("🇮🇶IQD   이라크   -   이라크 디나르", comment:"")),
        Currency(symbol: "﷼", name: NSLocalizedString("🇮🇷IRR   이란   -   이란 리알", comment:"")),
        Currency(symbol: "Kr", name: NSLocalizedString("🇮🇸ISK   아이슬란드   -   아이슬란드 크로나", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇯🇲JMD   자메이카   -   자메이카 달러", comment:"")),
        Currency(symbol: "د.ا", name: NSLocalizedString("🇯🇴JOD   요르단   -   요르단 디나르", comment:"")),
        Currency(symbol: "¥", name: NSLocalizedString("🇯🇵JPY   일본   -   엔", comment:"")),
        Currency(symbol: "Sh", name: NSLocalizedString("🇰🇪KES   케냐   -   케냐 실링", comment:"")),
        Currency(symbol: "c", name: NSLocalizedString("🇰🇬KGS   키르기스스탄   -   키르기스스탄 솜", comment:"")),
        Currency(symbol: "៛", name: NSLocalizedString("🇰🇭KHR   캄보디아   -   캄보디아 리엘", comment:"")),
        Currency(symbol: "CF", name: NSLocalizedString("🇰🇲KMF   코모로   -   코모로 프랑", comment:"")),
        Currency(symbol: "원", name: NSLocalizedString("🇰🇵KPW   조선민주주의인민공화국   -   원", comment:"")),
        Currency(symbol: "원", name: NSLocalizedString("🇰🇷KRW   대한민국   -   원", comment:"")),
        Currency(symbol: "د.ك", name: NSLocalizedString("🇰🇼KWD   쿠웨이트   -   디나르", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇰🇾KYD   케이맨 제도   -   달러", comment:"")),
        Currency(symbol: "〒", name: NSLocalizedString("🇰🇿KZT   카자흐스탄   -   텡게", comment:"")),
        Currency(symbol: "₭", name: NSLocalizedString("🇱🇦LAK   라오스   -   킵", comment:"")),
        Currency(symbol: "ل.ل", name: NSLocalizedString("🇱🇧LBP   레바논   -   파운드", comment:"")),
        Currency(symbol: "Rs", name: NSLocalizedString("🇱🇰LKR   스리랑카   -   루피", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇱🇷LRD   라이베리아   -   달러", comment:"")),
        Currency(symbol: "L", name: NSLocalizedString("🇱🇸LSL   레소토   -   로티", comment:"")),
        Currency(symbol: "ل.د", name: NSLocalizedString("🇱🇾LYD   리비아   -   디나르", comment:"")),
        Currency(symbol: "د.م.", name: NSLocalizedString("🇲🇦MAD   모로코   -   디르함", comment:"")),
        Currency(symbol: "L", name: NSLocalizedString("🇲🇩MDL   몰도바   -   레우", comment:"")),
        Currency(symbol: "Ar", name: NSLocalizedString("🇲🇬MGA   마다가스카르   -   아리아리", comment:"")),
        Currency(symbol: "ден", name: NSLocalizedString("🇲🇰MKD   마케도니아   -   데나르", comment:"")),
        Currency(symbol: "K", name: NSLocalizedString("🇲🇲MMK   미얀마   -   짯", comment:"")),
        Currency(symbol: "₮", name: NSLocalizedString("🇲🇳MNT   몽골   -   투그릭", comment:"")),
        Currency(symbol: "P", name: NSLocalizedString("🇲🇴MOP   마카오   -   파타카", comment:"")),
        Currency(symbol: "UM", name: NSLocalizedString("🇲🇷MRO   모리타니   -   우기야", comment:"")),
        Currency(symbol: "₨", name: NSLocalizedString("🇲🇺MUR   모리셔스   -   루피", comment:"")),
        Currency(symbol: "ރ.", name: NSLocalizedString("🇲🇻MVR   몰디브   -   루피야", comment:"")),
        Currency(symbol: "MK", name: NSLocalizedString("🇲🇼MWK   말라위   -   콰차", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇲🇽MXN   멕시코   -   페소", comment:"")),
        Currency(symbol: "RM", name: NSLocalizedString("🇲🇾MYR   말레이시아   -   링깃", comment:"")),
        Currency(symbol: "MTn", name: NSLocalizedString("🇲🇿MZN   모잠비크   -   메티칼", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇳🇦NAD   나미비아   -   달러", comment:"")),
        Currency(symbol: "₦", name: NSLocalizedString("🇳🇬NGN   나이지리아   -   나이라", comment:"")),
        Currency(symbol: "C$", name: NSLocalizedString("🇳🇮NIO   니카라과   -   코르도바", comment:"")),
        Currency(symbol: "kr", name: NSLocalizedString("🇳🇴NOK   노르웨이   -   크로네", comment:"")),
        Currency(symbol: "₨", name: NSLocalizedString("🇳🇵NPR   네팔   -   루피", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇳🇿NZD   뉴질랜드   -   달러", comment:"")),
        Currency(symbol: "ر.ع.", name: NSLocalizedString("🇴🇲OMR   오만   -   리알", comment:"")),
        Currency(symbol: "B/.", name: NSLocalizedString("🇵🇦PAB   파나마   -   발보아", comment:"")),
        Currency(symbol: "S/.", name: NSLocalizedString("🇵🇪PEN   페루   -   솔", comment:"")),
        Currency(symbol: "K", name: NSLocalizedString("🇵🇬PGK   파푸아뉴기니   -   키나", comment:"")),
        Currency(symbol: "₱", name: NSLocalizedString("🇵🇭PHP   필리핀   -   페소", comment:"")),
        Currency(symbol: "₨", name: NSLocalizedString("🇵🇰PKR   파키스탄   -   루피", comment:"")),
        Currency(symbol: "zł", name: NSLocalizedString("🇵🇱PLN   폴란드 즈워티", comment:"")),
        Currency(symbol: "₲", name: NSLocalizedString("🇵🇾PYG   파라과이   -   과라니", comment:"")),
        Currency(symbol: "ر.ق", name: NSLocalizedString("🇶🇦QAR   카타르   -   리얄", comment:"")),
        Currency(symbol: "L", name: NSLocalizedString("🇷🇴RON   루마니아   -   레우", comment:"")),
        Currency(symbol: "din", name: NSLocalizedString("🇷🇸RSD   세르비아   -   디나르", comment:"")),
        Currency(symbol: "р.", name: NSLocalizedString("🇷🇺RUB   러시아   -   루블", comment:"")),
        Currency(symbol: "₣", name: NSLocalizedString("🇷🇼RWF   르완다   -   프랑", comment:"")),
        Currency(symbol: "ر.س", name: NSLocalizedString("🇸🇦SAR   사우디아라비아   -   리얄", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇸🇧SBD   솔로몬 제도   -   달러", comment:"")),
        Currency(symbol: "₨", name: NSLocalizedString("🇸🇨SCR   세이셸   -   루피", comment:"")),
        Currency(symbol: "£", name: NSLocalizedString("🇸🇩SDG   수단   -   파운드", comment:"")),
        Currency(symbol: "kr", name: NSLocalizedString("🇸🇪SEK   스웨덴   -   크로나", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇸🇬SGD   싱가포르   -   달러", comment:"")),
        Currency(symbol: "£", name: NSLocalizedString("🇸🇭SHP   헬레나   -   파운드", comment:"")),
        Currency(symbol: "Le", name: NSLocalizedString("🇸🇱SLL   시에라리온   -   시에라리온", comment:"")),
        Currency(symbol: "Sh", name: NSLocalizedString("🇸🇴SOS   소말리아   -   실링", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇸🇷SRD   수리남   -   달러", comment:"")),
        Currency(symbol: "£", name: NSLocalizedString("🇸🇸SSP   남수단   -   파운드", comment:"")),
        Currency(symbol: "Db", name: NSLocalizedString("🇸🇹STD   상투메 프린시페   -   도브라", comment:"")),
        Currency(symbol: "₡", name: NSLocalizedString("🇸🇻SVC   엘살바도르   -   콜론", comment:"")),
        Currency(symbol: "ل.س", name: NSLocalizedString("🇸🇾SYP   시리아   -   파운드", comment:"")),
        Currency(symbol: "L", name: NSLocalizedString("🇸🇿SZL   에스와티니   -   릴랑게니", comment:"")),
        Currency(symbol: "฿", name: NSLocalizedString("🇹🇭THB   태국   -   바트", comment:"")),
        Currency(symbol: "ЅМ", name: NSLocalizedString("🇹🇯TJS   타지키스탄   -   소모니", comment:"")),
        Currency(symbol: "m", name: NSLocalizedString("🇹🇲TMT   투르크메니스탄   -   마나트", comment:"")),
        Currency(symbol: "د.ت", name: NSLocalizedString("🇹🇳TND   튀니지   -   디나르", comment:"")),
        Currency(symbol: "T$", name: NSLocalizedString("🇹🇴TOP   통가   -   팡가", comment:"")),
        Currency(symbol: "₤", name: NSLocalizedString("🇹🇷TRY   튀르키예   -   리라", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇹🇹TTD   트리니다드 토바고   -   달러", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇹🇼TWD   대만   -   신 대만 달러", comment:"")),
        Currency(symbol: "Sh", name: NSLocalizedString("🇹🇿TZS   탄자니아   -   실링", comment:"")),
        Currency(symbol: "₴", name: NSLocalizedString("🇺🇦UAH   우크라이나   -   흐리우냐", comment:"")),
        Currency(symbol: "Sh", name: NSLocalizedString("🇺🇬UGX   우간다   -   실링", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇺🇸USD   미국   -   달러", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇺🇾UYU   우루과이   -   페소", comment:"")),
        Currency(symbol: "UZS", name: NSLocalizedString("🇺🇿UZS   우즈베키스탄   -   숨", comment:"")),
        Currency(symbol: "Bs", name: NSLocalizedString("🇻🇪VEF   베네수엘라   -   볼리바르", comment:"")),
        Currency(symbol: "₫", name: NSLocalizedString("🇻🇳VND   베트남   -   동", comment:"")),
        Currency(symbol: "Vt", name: NSLocalizedString("🇻🇺VUV   바누아투   -   바투", comment:"")),
        Currency(symbol: "T", name: NSLocalizedString("🇼🇸WST   사모아   -   탈라", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇩🇲XCD   도미니카   -   동카리브 달러", comment:"")),
        Currency(symbol: "﷼", name: NSLocalizedString("🇾🇪YER   예멘   -   리알", comment:"")),
        Currency(symbol: "R", name: NSLocalizedString("🇿🇦ZAR   남아프리카   -   란드", comment:"")),
        Currency(symbol: "ZK", name: NSLocalizedString("🇿🇲ZMW   잠비아   -   크와차", comment:"")),
        Currency(symbol: "$", name: NSLocalizedString("🇿🇼ZWL   짐바브웨   -   달러", comment:""))
        
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(currencies.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { currency in
                    Button {
                        currencySelect = true
                        selectedCurrencyID = currency.id
                        selectedCurrency = currency.symbol
                        selectedCurrencyName = String(currency.name.prefix(4))
                        UserDefaults.standard.set(selectedCurrency, forKey: "selectedCurrency")
                        UserDefaults.standard.set(selectedCurrencyID, forKey: "selectedCurrencyID")
                        updateCurrencyFormats(for: currency.symbol)
                        dismiss()
                    } label: {
                        HStack {
                            Text("\(currency.name)")
                                .foregroundStyle(Color.black)
                        }
                        .contentShape(Rectangle())
                    }
                }
            }
            .onAppear {
                //로컬라이즈 시에 .onapear로 기본 통화 처리필요 (한,일,중,미 외에는 달러로 처리 되도록)
                selectedCurrencyID = UserDefaults.standard.string(forKey: "selectedCurrencyID") ?? currencies.first?.id ?? ""
                selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "원"
                if let selectedCurrencyObject = currencies.first(where: { $0.id == selectedCurrencyID }) {
                    selectedCurrencyName = String(selectedCurrencyObject.name.prefix(4))
                }
                if let selectedCurrencyObject = currencies.first(where: { $0.symbol == selectedCurrencyID }) {
                    selectedCurrencyName = String(selectedCurrencyObject.name.prefix(4))
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text(NSLocalizedString("검색", comment:"")))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(String(format:NSLocalizedString("현재 통화 : %@", comment:"") ,selectedCurrencyName))
            //앱 첫 실행시 툴바 숨겨야함
            .toolbar {
//                첫 실행시에 팝업으로 통화설정 보여주기/ 이후에는 돌아가기 버튼 계속 활성화됨
                if let currencySelect = currencySelect, currencySelect {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(NSLocalizedString("돌아가기", comment:"")) {
                            dismiss()
                        }
                        .tint(.cancel)
                    }
                }
                
            }
            
        }
    }
    private func updateCurrencyFormats(for currencySymbol: String) {
        let formatter = NumberFormatter()
        formatter.currencySymbol = currencySymbol
        
        
        if currencySymbol == "원" {
            // 대한민국 원화일 경우
            formatter.positiveFormat = "#,##0 원"
            formatter.negativeFormat = "- #,## 0원"
        }else if ["د.إ", "ب.د", "د.ج", "ع.د", "د.ا", "د.ك", "ل.د", "د.م.", "ރ.", "ر.ع.", "ر.ق", "ر.س", "ل.س", "د.ت", "﷼","ج.م"].contains(selectedCurrency)
        {
            // 특정 통화일 경우
            formatter.currencySymbol = currencySymbol
            Text("\(currencySymbol)")
            
            formatter.positiveFormat = "#,##0 ¤"
            formatter.negativeFormat = "#,##0 ¤ -"
            
        }
        else {
            // 그 외의 통화일 경우
            formatter.positiveFormat = "¤ #,##0"
            formatter.negativeFormat = "- ¤ #,##0"
        }
        
        // 적용된 형식을 UserDefaults에 저장 (EditExpenseView, AddExpenseView에서 사용할 수 있도록)
        UserDefaults.standard.set(try? NSKeyedArchiver.archivedData(withRootObject: formatter, requiringSecureCoding: false), forKey: "currencyFormatter")
    }
    
    
}

#Preview {
    CurrencySettingView()
}
