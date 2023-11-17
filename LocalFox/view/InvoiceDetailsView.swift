//
//  InvoiceDetailsView.swift
//  Local Fox
//
//  Created by venkatesh karra on 17/11/23.
//

import SwiftUI

struct InvoiceDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var invoice: InvoiceModel
    var body: some View {
        VStack {
            HStack {
                Text(Strings.INVOICE_DETAILS).applyFontHeader()
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
                        let status = InvoiceStatus(rawValue: invoice.invoiceStatus) ?? .Draft
                        Text("•").applyFontRegular(color: status.textColor, size: 20).padding(.bottom, 2)
                        Text(status.text).applyFontRegular(color: Color.DEFAULT_TEXT, size: 10)
                    }
                    
                    if let createdDate = invoice.createdDate.detailedDate {
                        Text("\(Strings.CREATED) \(createdDate)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 11)
                    }
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(Strings.CUSTOMER).applyFontBold(color: Color.DEFAULT_TEXT, size: 13)
                            Text("\(invoice.partner.firstName) \(invoice.partner.lastName)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                            Text("\(invoice.partner.location.getShortFormattedLocation())").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 3) {
                            Text(Strings.DETAILS).applyFontBold(color: Color.DEFAULT_TEXT, size: 13)
                            Text("\(Strings.REF) \(invoice.invoiceReference)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                            if let date  = invoice.invoiceDueDate.convertDateFormate(sorceFormate: DateFormates.API_DATE_TIME, destinationFormate: DateFormates.SHORT_DATE_TIME) {
                                Text("\(Strings.PAID_ON) \(date)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                            }
                        }
                    }.padding(.top, 10)
                        .padding(.bottom, 15)
                    
                    Text(Strings.LINE_ITEMS).applyFontBold(color: Color.DEFAULT_TEXT, size: 14)
                    ForEach(0 ..< invoice.items.count, id: \.self) {index in
                        let item = invoice.items[index]
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
                                Text("$\(invoice.subTotal, specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT, size: 16)
                                Text("$\(invoice.totalTax, specifier: "%.2f")").applyFontMedium(color: Color.DEFAULT_TEXT, size: 16)
                                Text("$\(invoice.totalPrice, specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT, size: 18).padding(.top, 20)
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


