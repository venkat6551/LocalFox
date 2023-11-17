//
//  QuoteDetailsView.swift
//  Local Fox
//
//  Created by venkatesh karra on 15/11/23.
//

import SwiftUI

struct QuoteDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var quote: QuoteModel
    var body: some View {
        VStack {
            HStack {
                Text(Strings.QUOTE_DETAILS).applyFontHeader()
                Spacer()
                Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        VStack {
                            Images.CLOSE
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12,height: 12)
                        } .frame(width: 34,height: 34)
                            .cardify(cardCornerRadius: 15)
                            .background(Color.SCREEN_BG)
                    }
                )
            }.padding(.top, 25)
            ScrollView {
                VStack (alignment: .leading){
                        HStack(alignment: .center, spacing: 3) {
                        Text("•").applyFontRegular(color: Color.TEXT_GREEN, size: 20)
                        let status = QuoteStatus(rawValue: quote.quoteStatus) ?? .Draft
                        Text(status.text).applyFontRegular(color: Color.DEFAULT_TEXT, size: 10)
                    }
                    
                    if let createdDate = quote.createdDate.detailedDate {
                        Text("\(Strings.CREATED) \(createdDate)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 11)
                    }
                    
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(Strings.CUSTOMER).applyFontBold(color: Color.DEFAULT_TEXT, size: 13)
                            Text("\(quote.partner.firstName) \(quote.partner.lastName)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                            Text("\(quote.partner.location.getShortFormattedLocation())").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 3) {
                            Text(Strings.DETAILS).applyFontBold(color: Color.DEFAULT_TEXT, size: 13)
                            Text("\(Strings.QUOTE) \(quote.quoteReference)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                            if let date  = quote.quoteExpiry.convertDateFormate(sorceFormate: DateFormates.API_DATE_TIME, destinationFormate: DateFormates.SHORT_DATE_TIME) {
                                Text("\(Strings.EXPIRY) \(date)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                            }
                            Text("Sent to customer").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11).padding(4).cardify(cardBgColor: Color.LIGHT_GREEN)
                        }
                    }.padding(.top, 10)
                        .padding(.bottom, 15)
                    
                    Text(Strings.LINE_ITEMS).applyFontBold(color: Color.DEFAULT_TEXT, size: 14)
                    ForEach(0 ..< quote.items.count, id: \.self) {index in
                        let item = quote.items[index]
                        QuoteLineItemView(item: item)
                    }
                    HStack() {
                        Spacer()
                        HStack(spacing: 50) {
                            VStack(alignment: .trailing, spacing: 10){
                                Text(Strings.SUB_TOTAL).applyFontBold(color: Color.DEFAULT_TEXT, size: 16)
                                Text(Strings.TAX).applyFontMedium(color: Color.DEFAULT_TEXT, size: 15)
                                Text(Strings.TOTAL).applyFontBold(color: Color.DEFAULT_TEXT, size: 16).padding(.top, 20)
                            }
                            VStack(alignment: .trailing, spacing: 10){
                                Text("$\(quote.subTotal, specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT, size: 16)
                                Text("$\(quote.totalTax, specifier: "%.2f")").applyFontMedium(color: Color.DEFAULT_TEXT, size: 16)
                                Text("$\(quote.totalPrice, specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT, size: 18).padding(.top, 20)
                            }
                        }
                    }.padding(.top,20)
                    
                    Spacer()
                }
            }
            VStack {
                HStack(spacing: 15) {
                    MyButton(text: Strings.SEND_EMAIL,onClickButton: {
                        
                    } ,bgColor: Color.TEXT_GREEN)
                    MyButton(text: Strings.DELETE,onClickButton: {
                        
                    } ,bgColor: Color.PRIMARY)
                }.padding(.top,15)
                MyButton(text: Strings.CONVERT_TO_INVOICE,onClickButton: {
                    
                } ).padding(.top,5)
            }
        }
        .navigationBarHidden(true)
        .padding(.horizontal, 15)
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
}


struct QuoteLineItemView: View {
    let item: QuoteItemModel
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 5)  {
                Text ("Tax Exclusive").applyFontRegular(color: Color.TEXT_GREEN,size: 11).padding(.horizontal,8).cardify(contentPadding: 4,borderColor: Color.TEXT_GREEN)
                    .padding(.bottom, 5)
                Text ("\(item.serviceName)").applyFontMedium(size: 14)
                Text ("\(item.serviceDescription)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 12)
            }.padding(.leading, 10)
            Spacer()
            VStack(alignment: .trailing,spacing: 5) {
                Text ("$\(item.totalItemPrice, specifier: "%.0f")").applyFontBold(color:Color.DEFAULT_TEXT,size: 20)
                Text (Strings.INC_GST).applyFontBold(size: 9)
            }
            .frame(width: 96, height: 61)
            .cardify(cardBgColor: Color.BG_COLOR_1)
            .padding(10)
        }.frame(maxWidth: .infinity).cardify()
        
    }
}

//#Preview {
//    QuoteDetailsView()
//}
