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
    @State private var selectedCurrencyName: String = ""
    struct Currency: Identifiable {
            var id: String { symbol + name}
            let symbol: String
            let name: String
        
        }

    let currencies: [Currency] = [
        
            Currency(symbol: "د.إ", name: "🇦🇪AED   아랍에미리트   -   디르함"), //표기안됨
            Currency(symbol: "Af", name: "🇦🇫AFN   아프카니스탄   -   아프가니"),
            Currency(symbol: "L", name: "🇦🇱ALL   알바니아   -   렉"),
            Currency(symbol: "Դ", name: "🇦🇲AMD   아르메니아   -   드람"),
            Currency(symbol: "Kz", name: "🇦🇴AOA   앙골라   -   콴자"),
            Currency(symbol: "$", name: "🇦🇷ARS   아르헨티나   -   페소"),
            Currency(symbol: "$", name: "🇦🇺AUD   오스트레일리아   -   달러"),
            Currency(symbol: "ƒ", name: "🇦🇼AWG   아루바   -   플로린"),
            Currency(symbol: "ман", name: "🇦🇿AZN   아제르바이잔   -   마나트"),
            Currency(symbol: "КМ", name: "🇧🇦BAM   보스니아 헤르체코비나   -   마커"),
            Currency(symbol: "$", name: "🇧🇧BBD   바베이도스   -   달러"),
            Currency(symbol: "৳", name: "🇧🇩BDT   방글라데시   -   타카"),
            Currency(symbol: "лв", name: "🇧🇬BGN   불가리아   -   불가리안 레프"),
            Currency(symbol: "ب.د", name: "🇧🇭BHD   바레인   -   디나르"), //표기안됨
            Currency(symbol: "₣", name: "🇧🇮BIF   브룬디   -   프랑"),
            Currency(symbol: "$", name: "🇧🇲BMD   버뮤다   -   버뮤디안 달러"),
            Currency(symbol: "$", name: "🇧🇳BND   브루나이   -   달러"),
            Currency(symbol: "Bs", name: "🇧🇴BOB   볼리비아   -   볼리비아노"),
            Currency(symbol: "R$", name: "🇧🇷BRL   브라질   -   브라질리안 헤알"),
            Currency(symbol: "$", name: "🇧🇸BSD   바하마   -   바하미안 달러"),
            Currency(symbol: "Nu", name: "🇧🇹BTN   부탄   -   눌트럼"),
            Currency(symbol: "P", name: "🇧🇼BWP   보츠와나   -   풀라"),
            Currency(symbol: "Br", name: "🇧🇾BYR   벨라루스   -   벨라루시안 루블"),
            Currency(symbol: "$", name: "🇧🇿BZD   벨리즈   -   달러"),
            Currency(symbol: "$", name: "🇨🇦CAD   캐나다   -   캐나다달러"),
            Currency(symbol: "₣", name: "🇨🇩CDF   콩고 킨샤사   -   프랑"),
            Currency(symbol: "₣", name: "🇨🇭CHF   스위스   -   프랑"),
            Currency(symbol: "$", name: "🇨🇱CLP   칠레   -   칠레니아 페소"),
            Currency(symbol: "¥", name: "🇨🇳CNY   중국   -   위안"),
            Currency(symbol: "$", name: "🇨🇴COP   콜롬비아   -   콜롬비안 페소"),
            Currency(symbol: "₡", name: "🇨🇷CRC   코스타리카   -   코스타리칸 콜론"),
            Currency(symbol: "$", name: "🇨🇺CUP   쿠바   -   쿠반 페소"),
            Currency(symbol: "$", name: "🇨🇻CVE   카보 베르데   -   카보 베르데 에스쿠도"),
            Currency(symbol: "Kč", name: "🇨🇿CZK   체코 공화국   -   체코 코루나"),
            Currency(symbol: "₣", name: "🇩🇯DJF   지부티   -   지부티 프랑"),
            Currency(symbol: "kr", name: "🇩🇰DKK   덴마크   -   덴마크 크로네"),
            Currency(symbol: "$", name: "🇩🇴DOP   도미니카 공화국   -   도미니카 페소"),
            Currency(symbol: "د.ج", name: "🇩🇿DZD   알제리   -   알제르 디나르"), //표기안됨
            Currency(symbol: "£", name: "🇪🇬EGP   이집트   -   이집트 파운드"),
            Currency(symbol: "Nfk", name: "🇪🇷ERN   에리트레아   -   낙파"),
            Currency(symbol: "Br", name: "🇪🇹ETB   에티오피아   -   에디오피안 비르"),
            Currency(symbol: "€", name: "🇪🇺EUR   유로"),
            Currency(symbol: "$", name: "🇫🇯FJD   피지   -   피지 달러"),
            Currency(symbol: "£", name: "🇫🇰FKP   포크랜드 제도   -   포크랜드 제도 파운드"),
            Currency(symbol: "£", name: "🇬🇧GBP   영국   -   파운드"),
            Currency(symbol: "ლ", name: "🇬🇪GEL   조지아   -   조지아 라리"),
            Currency(symbol: "₵", name: "🇬🇭GHS   가나   -   가나 세디"),
            Currency(symbol: "£", name: "🇬🇮GIP   지브롤터   -   지브롤터 파운드"),
            Currency(symbol: "D", name: "🇿🇲GMD   잠비아   -   달라시"),
            Currency(symbol: "₣", name: "🇬🇳GNF   기니아   -   기니아 프랑"),
            Currency(symbol: "Q", name: "🇬🇹GTQ   과테말라   -   케트살"),
            Currency(symbol: "$", name: "🇬🇾GYD   가이아나   -   가이아나 달러"),
            Currency(symbol: "$", name: "🇭🇰HKD   홍콩   -   홍콩달러"),
            Currency(symbol: "L", name: "🇭🇳HNL   온두라스   -   렘피라"),
            Currency(symbol: "G", name: "🇭🇹HTG   아이티   -   아이티 구르드"),
            Currency(symbol: "Ft", name: "🇭🇺HUF   헝가리   -   헝가리 포린트"),
            Currency(symbol: "Rp", name: "🇮🇩IDR   인도네시아   -   인도네시아 루피아"),
            Currency(symbol: "₪", name: "🇮🇱ILS   이스라엘   -   이스라엘 신 셰켈"),
            Currency(symbol: "₹", name: "🇮🇳INR   인도   -   인도 루피"),
            Currency(symbol: "ع.د", name: "🇮🇶IQD   이라크   -   이라크 디나르"), //표기안됨
            Currency(symbol: "﷼", name: "🇮🇷IRR   이란   -   이란 리알"),
            Currency(symbol: "Kr", name: "🇮🇸ISK   아이슬란드   -   아이슬란드 크로나"),
            Currency(symbol: "$", name: "🇯🇲JMD   자메이카   -   자메이카 달러"),
            Currency(symbol: "د.ا", name: "🇯🇴JOD   요르단   -   요르단 디나르"), //표기안됨
            Currency(symbol: "¥", name: "🇯🇵JPY   일본   -   엔"),
            Currency(symbol: "Sh", name: "🇰🇪KES   케냐   -   케냐 실링"),
            Currency(symbol: "c", name: "🇰🇬KGS   키르기스스탄   -   키르기스스탄 솜"),
            Currency(symbol: "៛", name: "🇰🇭KHR   캄보디아   -   캄보디아 리엘"),
            Currency(symbol: "CF", name: "🇰🇲KMF   코모로   -   코모로 프랑"),
            Currency(symbol: "원", name: "🇰🇵KPW   조선민주주의인민공화국   -   원"),
            Currency(symbol: "원", name: "🇰🇷KRW   대한민국   -   원"),
            Currency(symbol: "د.ك", name: "🇰🇼KWD   쿠웨이트   -   디나르"), //표기안됨
            Currency(symbol: "$", name: "🇰🇾KYD   케이맨 제도   -   달러"),
            Currency(symbol: "〒", name: "🇰🇿KZT   카자흐스탄   -   텡게"),
            Currency(symbol: "₭", name: "🇱🇦LAK   라오스   -   킵"),
            Currency(symbol: "ل.ل", name: "🇱🇧LBP   레바논   -   파운드"),
            Currency(symbol: "Rs", name: "🇱🇰LKR   스리랑카   -   루피"),
            Currency(symbol: "$", name: "🇱🇷LRD   라이베리아   -   달러"),
            Currency(symbol: "L", name: "🇱🇸LSL   레소토   -   로티"),
            Currency(symbol: "ل.د", name: "🇱🇾LYD   리비아   -   디나르"), //표기안됨
            Currency(symbol: "د.م.", name: "🇲🇦MAD   모로코   -   디르함"), //표기안됨
            Currency(symbol: "L", name: "🇲🇩MDL   몰도바   -   레우"),
            Currency(symbol: "Ar", name: "🇲🇬MGA   마다가스카르   -   아리아리"),
            Currency(symbol: "ден", name: "🇲🇰MKD   마케도니아   -   데나르"),
            Currency(symbol: "K", name: "🇲🇲MMK   미얀마   -   짯"),
            Currency(symbol: "₮", name: "🇲🇳MNT   몽골   -   투그릭"),
            Currency(symbol: "P", name: "🇲🇴MOP   마카오   -   파타카"),
            Currency(symbol: "UM", name: "🇲🇷MRO   모리타니   -   우기야"),
            Currency(symbol: "₨", name: "🇲🇺MUR   모리셔스   -   루피"),
            Currency(symbol: "ރ.", name: "🇲🇻MVR   몰디브   -   루피야"), //표기안됨
            Currency(symbol: "MK", name: "🇲🇼MWK   말라위   -   콰차"),
            Currency(symbol: "$", name: "🇲🇽MXN   멕시코   -   페소"),
            Currency(symbol: "RM", name: "🇲🇾MYR   말레이시아   -   링깃"),
            Currency(symbol: "MTn", name: "🇲🇿MZN   모잠비크   -   메티칼"),
            Currency(symbol: "$", name: "🇳🇦NAD   나미비아   -   달러"),
            Currency(symbol: "₦", name: "🇳🇬NGN   나이지리아   -   나이라"),
            Currency(symbol: "C$", name: "🇳🇮NIO   니카라과   -   코르도바"),
            Currency(symbol: "kr", name: "🇳🇴NOK   노르웨이   -   크로네"),
            Currency(symbol: "₨", name: "🇳🇵NPR   네팔   -   루피"),
            Currency(symbol: "$", name: "🇳🇿NZD   뉴질랜드   -   달러"),
            Currency(symbol: "ر.ع.", name: "🇴🇲OMR   오만   -   리알"), //표기안됨
            Currency(symbol: "B/.", name: "🇵🇦PAB   파나마   -   발보아"),
            Currency(symbol: "S/.", name: "🇵🇪PEN   페루   -   솔"),
            Currency(symbol: "K", name: "🇵🇬PGK   파푸아뉴기니   -   키나"),
            Currency(symbol: "₱", name: "🇵🇭PHP   필리핀   -   페소"),
            Currency(symbol: "₨", name: "🇵🇰PKR   파키스탄   -   루피"),
            Currency(symbol: "zł", name: "🇵🇱PLN   폴란드 즈워티"),
            Currency(symbol: "₲", name: "🇵🇾PYG   파라과이   -   과라니"),
            Currency(symbol: "ر.ق", name: "🇶🇦QAR   카타르   -   리얄"), //표기안됨
            Currency(symbol: "L", name: "🇷🇴RON   루마니아   -   레우"),
            Currency(symbol: "din", name: "🇷🇸RSD   세르비아   -   디나르"),
            Currency(symbol: "р.", name: "🇷🇺RUB   러시아   -   루블"),
            Currency(symbol: "₣", name: "🇷🇼RWF   르완다   -   프랑"),
            Currency(symbol: "ر.س", name: "🇸🇦SAR   사우디아라비아   -   리얄"), //표기안됨
            Currency(symbol: "$", name: "🇸🇧SBD   솔로몬 제도   -   달러"),
            Currency(symbol: "₨", name: "🇸🇨SCR   세이셸   -   루피"),
            Currency(symbol: "£", name: "🇸🇩SDG   수단   -   파운드"),
            Currency(symbol: "kr", name: "🇸🇪SEK   스웨덴   -   크로나"),
            Currency(symbol: "$", name: "🇸🇬SGD   싱가포르   -   달러"),
            Currency(symbol: "£", name: "🇸🇭SHP   헬레나   -   파운드"),
            Currency(symbol: "Le", name: "🇸🇱SLL   시에라리온   -   시에라리온"),
            Currency(symbol: "Sh", name: "🇸🇴SOS   소말리아   -   실링"),
            Currency(symbol: "$", name: "🇸🇷SRD   수리남   -   달러"),
            Currency(symbol: "£", name: "🇸🇸SSP   남수단   -   파운드"),
            Currency(symbol: "Db", name: "🇸🇹STD   상투메 프린시페   -   도브라"),
            Currency(symbol: "₡", name: "🇸🇻SVC   엘살바도르   -   콜론"),
            Currency(symbol: "ل.س", name: "🇸🇾SYP   시리아   -   파운드"), //표기안됨
            Currency(symbol: "L", name: "🇸🇿SZL   에스와티니   -   릴랑게니"),
            Currency(symbol: "฿", name: "🇹🇭THB   태국   -   바트"),
            Currency(symbol: "ЅМ", name: "🇹🇯TJS   타지키스탄   -   소모니"),
            Currency(symbol: "m", name: "🇹🇲TMT   투르크메니스탄   -   마나트"),
            Currency(symbol: "د.ت", name: "🇹🇳TND   튀니지   -   디나르"), //표기안됨
            Currency(symbol: "T$", name: "🇹🇴TOP   통가   -   팡가"),
            Currency(symbol: "₤", name: "🇹🇷TRY   튀르키예   -   리라"),
            Currency(symbol: "$", name: "🇹🇹TTD   트리니다드 토바고   -   달러"),
            Currency(symbol: "$", name: "🇹🇼TWD   대만   -   신 대만 달러"),
            Currency(symbol: "Sh", name: "🇹🇿TZS   탄자니아   -   실링"),
            Currency(symbol: "₴", name: "🇺🇦UAH   우크라이나   -   흐리우냐"),
            Currency(symbol: "Sh", name: "🇺🇬UGX   우간다   -   실링"),
            Currency(symbol: "$", name: "🇺🇸USD   미국   -   달러"),
            Currency(symbol: "$", name: "🇺🇾UYU   우루과이   -   페소"),
            Currency(symbol: "UZS", name: "🇺🇿UZS   우즈베키스탄   -   숨"),
            Currency(symbol: "Bs", name: "🇻🇪VEF   베네수엘라   -   볼리바르"),
            Currency(symbol: "₫", name: "🇻🇳VND   베트남   -   동"),
            Currency(symbol: "Vt", name: "🇻🇺VUV   바누아투   -   바투"),
            Currency(symbol: "T", name: "🇼🇸WST   사모아   -   탈라"),
            Currency(symbol: "$", name: "🇩🇲XCD   도미니카   -   동카리브 달러"),
            Currency(symbol: "﷼", name: "🇾🇪YER   예멘 리알"), //표기안됨
            Currency(symbol: "R", name: "🇿🇦ZAR   남아프리카   -   란드"),
            Currency(symbol: "ZK", name: "🇿🇲ZMW   잠비아   -   크와차"),
            Currency(symbol: "$", name: "🇿🇼ZWL   짐바브웨   -   달러")

        ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(currencies.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { currency in
                    Button {
                        selectedCurrency = currency.symbol
                        selectedCurrencyName = String(currency.name.prefix(4)) // Take the first 4 characters
                          UserDefaults.standard.set(selectedCurrency, forKey: "selectedCurrency")
                        updateCurrencyFormats(for: currency.symbol) // 여기에서 업데이트 함수 호출

                          dismiss()
                        // 여기에서 필요한 작업 수행
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
                selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "원"
                if let selectedCurrencyObject = currencies.first(where: { $0.symbol == selectedCurrency }) {
                                   selectedCurrencyName = String(selectedCurrencyObject.name.prefix(4))
                               }
                       }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("검색"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("현재 통화: \(selectedCurrencyName)")
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
    private func updateCurrencyFormats(for currencySymbol: String) {
            let formatter = NumberFormatter()
            formatter.currencySymbol = currencySymbol
        

        if currencySymbol == "원" {
            // 대한민국 원화일 경우
            formatter.positiveFormat = "#,##0원"
            formatter.negativeFormat = "-#,##0원"
        } else {
                // 그 외의 통화일 경우
                formatter.positiveFormat = "¤ #,##0"
                formatter.negativeFormat = "-¤ #,##0"
            }

            // 적용된 형식을 UserDefaults에 저장 (EditExpenseView, AddExpenseView에서 사용할 수 있도록)
            UserDefaults.standard.set(try? NSKeyedArchiver.archivedData(withRootObject: formatter, requiringSecureCoding: false), forKey: "currencyFormatter")
        }
    

}

#Preview {
    CurrencySettingView()
}
