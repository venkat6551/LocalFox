//
//  QuoteDetailsView.swift
//  Local Fox
//
//  Created by venkatesh karra on 15/11/23.
//

import SwiftUI

struct CreateQuoteView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var quoteViewModel: QuoteViewModel
    @State private var showAddLineItem = false
    @State private var showErrorSneakBar = false
    @State private var showsuccessSneakBar = false
    var body: some View {
        VStack {
            HStack {
                Text(Strings.CREATE_QUOTE).applyFontHeader()
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
            ScrollView(showsIndicators: false) {
                if let data = quoteViewModel.quoteModel?.data {
                    VStack (alignment: .leading){
                            HStack(alignment: .center, spacing: 3) {
                                Text("•").applyFontRegular(color: Color.TEXT_GREEN, size: 20).padding(.bottom, 2)
                                let status = QuoteStatus(rawValue: data.quoteStatus) ?? .Draft
                                Text(status.text).applyFontRegular(color: Color.DEFAULT_TEXT, size: 10)
                            }
                        
                        if let createdDate = data.createdDate.detailedDate {
                            Text("\(Strings.CREATED) \(createdDate)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 11)
                        }
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(Strings.CUSTOMER).applyFontBold(color: Color.DEFAULT_TEXT, size: 13)
                                Text("\(data.partner.firstName) \(data.partner.lastName)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                                Text("\(data.partner.location.getShortFormattedLocation())").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 3) {
                                Text(Strings.DETAILS).applyFontBold(color: Color.DEFAULT_TEXT, size: 13)
                                Text("\(Strings.QUOTE) \(data.quoteReference)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                                if let date  = data.quoteExpiry.convertDateFormate(sorceFormate: DateFormates.API_DATE_TIME, destinationFormate: DateFormates.SHORT_DATE_TIME) {
                                    Text("\(Strings.EXPIRY) \(date)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                                }
                            }
                        }.padding(.top, 10)
                            .padding(.bottom, 15)
                        HStack {
                            Text(Strings.LINE_ITEMS).applyFontBold(color: Color.DEFAULT_TEXT, size: 16)
                            Spacer()
                            Button {
                                showAddLineItem = true
                            } label: {
                                HStack{
                                    Images.PLUS_ICON
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12,height: 12)
                                    
                                    Text("Item").applyFontBold(color: Color.white, size: 12)
                                }
                            }.frame(width: 77, height: 27).background(Color.PRIMARY).cardify()
                        }
                        
                        if (!data.items.isEmpty) {
                            ForEach(0 ..< data.items.count, id: \.self) {index in
                                let item = data.items[index]
                                QuoteLineItemView(item: item, editEnabled: true) {
                                    quoteViewModel.deleteLineItem(item: item)
                                }
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
                                        Text("$\(quoteViewModel.getSubtotal(), specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT , size: 16)
                                        Text("$\(quoteViewModel.getTotalTax(), specifier: "%.2f")").applyFontMedium(color: Color.DEFAULT_TEXT, size: 16)
                                        Text("$\(quoteViewModel.getTotalPrice(), specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT, size: 18).padding(.top, 20)
                                    }
                                }
                            }.padding(.top,20)
                            Spacer()
                            VStack {
                                HStack(spacing: 15) {
                                    MyButton(text: Strings.SEND_EMAIL,onClickButton: {
                                        quoteViewModel.sendQuote()
                                    } ,showLoading: quoteViewModel.isSendQuoteLoading, bgColor: Color.TEXT_GREEN)
                                    MyButton(text: Strings.SAVE,onClickButton: {
                                        quoteViewModel.saveQuote()
                                    }, showLoading: quoteViewModel.isSaveQuoteLoading, bgColor: Color.SECONDARY)
                                }.padding(.top,15)
                            }
                        }
                    }
                }
            }
        }.disabled(quoteViewModel.isSaveQuoteLoading || quoteViewModel.isSendQuoteLoading)
        .navigationBarHidden(true)
        .padding(.horizontal, 15)
        .background(Color.SCREEN_BG.ignoresSafeArea())
        .sheet(isPresented:  $showAddLineItem) {
            AddQuoteLineItemView(quoteViewModel: quoteViewModel)
        }
        .onChange(of: quoteViewModel.isSendQuoteLoading) { isloading in
            if (quoteViewModel.saveOrSendQuoteSuccess == true && quoteViewModel.errorString == nil) {
                self.showsuccessSneakBar = true
            } else if(quoteViewModel.errorString != nil) {
                self.showErrorSneakBar = true
            }
        }
        
        .onChange(of: quoteViewModel.isSaveQuoteLoading) { isloading in
            if (quoteViewModel.saveOrSendQuoteSuccess == true && quoteViewModel.errorString == nil) {
                self.showsuccessSneakBar = true
            } else if(quoteViewModel.errorString != nil) {
                self.showErrorSneakBar = true
            }
        }
        .snackbar(
            show: $showsuccessSneakBar,
            snackbarType: SnackBarType.success,
            title: "Success",
            message: "Quote Saved/Emailed SuccessFully",
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {
                self.presentationMode.wrappedValue.dismiss()
                NotificationCenter.default.post(name: NSNotification.RELOAD_JOB_DETAILS,
                                                object: nil, userInfo: nil)
                
            }
            ,
            isAlignToBottom: true
        )
        .snackbar(
            show: $showErrorSneakBar,
            snackbarType: SnackBarType.error,
            title: "Error",
            message: quoteViewModel.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: { },
            isAlignToBottom: true
        )
    }
}


struct QuoteLineItemView: View {
    let item: QuoteItemModel
    var editEnabled = false
    var deleteClicked : () -> Void
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                VStack(alignment: .leading, spacing: 5)  {
                    Text (getTaxTypeName()).applyFontRegular(color: Color.TEXT_GREEN,size: 11).padding(.horizontal,8).cardify(contentPadding: 4,borderColor: Color.TEXT_GREEN)
                        .padding(.bottom, 5)
                        .padding(.top, 15)
                    Text ("\(item.serviceName)").applyFontMedium(size: 14)
                    Text ("\(item.serviceDescription)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 12)
                        .padding(.bottom, 15)
                }.padding(.leading, 10)
                Spacer()
                VStack(alignment: .trailing,spacing: 5) {
                    Text ("$\(item.price, specifier: "%.0f")").applyFontBold(color:Color.DEFAULT_TEXT,size: 20)
                    Text (Strings.INC_GST).applyFontBold(size: 9)
                }
                .frame(width: 96, height: 71)
                .cardify(cardBgColor: Color.BG_COLOR_1)
                .padding(10)
            }.frame(maxWidth: .infinity).cardify().padding(editEnabled ? 6 : 0)
            if editEnabled {
                
                
                Button {
                    deleteClicked()
                } label: {
                    Images.RED_CLOSE_ROUND
                }

               
            }
        }
      
    }
    
    
    func getTaxTypeName() -> String {
        switch item.taxType {
        case "TAX_EXCLUSIVE": return "Tax Exclusive"
        case "TAX_INCLUSIVE": return "Tax Inclusive"
        default: return "No Tax"
        }
    }
}

