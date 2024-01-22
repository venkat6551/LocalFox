//
//  ViewQuoteDetailsView.swift
//  Local Fox
//
//  Created by venkatesh karra on 11/01/24.
//

import SwiftUI

struct ViewQuoteDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var quote: QuoteModel
    var quoteViewModel: QuoteViewModel = QuoteViewModel()
    
    @StateObject var invoiceViewModel: InvoiceViewModel  = InvoiceViewModel()
    @State private var showAddLineItem = false
    @State private var showErrorSneakBar = false
    @State private var showInvoiceErrorSneakBar = false
    @State private var showsuccessSneakBar = false
    @State private var showCreateInvoicePage = false
    let pub = NotificationCenter.default
                .publisher(for: NSNotification.Name("YourNameHere"))
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
            ScrollView (showsIndicators: false){
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
                        }
                    }.padding(.top, 10)
                        .padding(.bottom, 15)
                    HStack {
                        Text(Strings.LINE_ITEMS).applyFontBold(color: Color.DEFAULT_TEXT, size: 16)
                        Spacer()
                    }
                    if (!quote.items.isEmpty){
                       
                        ForEach(0 ..< quote.items.count, id: \.self) {index in
                            let item = quote.items[index]
                            QuoteLineItemView(item: item){
                                //do nothing
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
                                   // Text("$\(quote.subTotal ?? 0, specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT , size: 16)
                                    Text("$\(quote.totalTax ?? 0, specifier: "%.2f")").applyFontMedium(color: Color.DEFAULT_TEXT, size: 16)
                                    Text("$\(quote.totalPrice ?? 0, specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT, size: 18).padding(.top, 20)
                                }
                            }
                        }.padding(.top,20)
                        Spacer()
                        VStack {
                            HStack(spacing: 15) {
                                MyButton(text: Strings.SEND_EMAIL,onClickButton: {
                                    quoteViewModel.sendQuote()
                                }, showLoading: quoteViewModel.isSendQuoteLoading ,bgColor: Color.TEXT_GREEN)
                                MyButton(text: Strings.DELETE,onClickButton: {
                                    
                                } ,bgColor: Color.PRIMARY)
                            }.padding(.top,15)
                            MyButton(text: Strings.CONVERT_TO_INVOICE,onClickButton: {
                                invoiceViewModel.convertToInvoice(quoteID: quote._id)
                            }, showLoading: invoiceViewModel.isLoading ).padding(.top,5)
                        }
                    }
                }
            }
        }.disabled(invoiceViewModel.isLoading || quoteViewModel.isSendQuoteLoading)
        .onAppear{
                       quoteViewModel.quoteModel = NewQuoteModel(success: true, data: quote)
        }
        .onChange(of: invoiceViewModel.isLoading) { isloading in
            if (invoiceViewModel.convertToInvoiceSuccess == true && invoiceViewModel.errorString == nil && invoiceViewModel.invoiceModel != nil) {
                self.showCreateInvoicePage = true
            } else if(invoiceViewModel.isLoading != true && invoiceViewModel.errorString != nil) {
                self.showInvoiceErrorSneakBar = true
            }
        }
        .onChange(of: quoteViewModel.isSendQuoteLoading) { isloading in
            if (quoteViewModel.saveOrSendQuoteSuccess == true && quoteViewModel.errorString == nil ) {
                self.showsuccessSneakBar = true
            } else if(quoteViewModel.errorString != nil) {
                self.showErrorSneakBar = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.CLOSE_QUOTE_DETAILS))
                { obj in
                    self.presentationMode.wrappedValue.dismiss()
                }
       
        .snackbar(
            show: $showsuccessSneakBar,
            snackbarType: SnackBarType.success,
            title: "Success",
            message: "Quote Emailed SuccessFully",
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {self.presentationMode.wrappedValue.dismiss()},
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
        .snackbar(
            show: $showInvoiceErrorSneakBar,
            snackbarType: SnackBarType.error,
            title: "Error",
            message: invoiceViewModel.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: { },
            isAlignToBottom: true
        )
        .navigationDestination(isPresented: $showCreateInvoicePage) {
            if invoiceViewModel.invoiceModel != nil {
                CreateInvoiceView(invoiceViewModel: invoiceViewModel, isFromQuote:true)
            }
        }
        .navigationBarHidden(true)
        .padding(.horizontal, 15)
        .background(Color.SCREEN_BG.ignoresSafeArea())
       
    }
}

//#Preview {
//    ViewQuoteDetailsView()
//}
