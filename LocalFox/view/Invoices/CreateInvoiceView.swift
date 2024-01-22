//
//  CreateInvoiceView.swift
//  Local Fox
//
//  Created by venkatesh karra on 20/01/24.
//

import SwiftUI

struct CreateInvoiceView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var invoiceViewModel: InvoiceViewModel
    @State private var showAddLineItem = false
    @State private var showErrorSneakBar = false
    @State private var showsuccessSneakBar = false
    var body: some View {
        VStack {
            HStack {
                Text(Strings.CREATE_INVOICE).applyFontHeader()
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
                if let data = invoiceViewModel.invoiceModel?.data {
                    VStack (alignment: .leading){
                            HStack(alignment: .center, spacing: 3) {
                                Text("•").applyFontRegular(color: Color.TEXT_GREEN, size: 20).padding(.bottom, 2)
                                let status = InvoiceStatus(rawValue: data.invoiceStatus) ?? .Draft
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
                                Text("\(Strings.QUOTE) \(data.invoiceReference)").applyFontRegular(color: Color.DEFAULT_TEXT, size: 11)
                                if let date  = data.invoiceDueDate.convertDateFormate(sorceFormate: DateFormates.API_DATE_TIME, destinationFormate: DateFormates.SHORT_DATE_TIME) {
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
                                QuoteLineItemView(item: item, editEnabled: true){
                                    invoiceViewModel.deleteLineItem(item: item)
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
                                        Text("$\(invoiceViewModel.getSubtotal(), specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT , size: 16)
                                        Text("$\(invoiceViewModel.getTotalTax(), specifier: "%.2f")").applyFontMedium(color: Color.DEFAULT_TEXT, size: 16)
                                        Text("$\(invoiceViewModel.getTotalPrice(), specifier: "%.2f")").applyFontBold(color: Color.DEFAULT_TEXT, size: 18).padding(.top, 20)
                                    }
                                }
                            }.padding(.top,20)
                            Spacer()
                            VStack {
                                HStack(spacing: 15) {
                                    MyButton(text: Strings.SEND_EMAIL,onClickButton: {
                                        invoiceViewModel.sendInvoice()
                                    } ,showLoading: invoiceViewModel.isSendInvoiceLoading, bgColor: Color.TEXT_GREEN)
                                    MyButton(text: Strings.SAVE,onClickButton: {
                                        invoiceViewModel.saveInvoice()
                                    }, showLoading: invoiceViewModel.isSaveInvoiceLoading, bgColor: Color.SECONDARY)
                                }.padding(.top,15)
                            }
                        }
                    }
                }
            }
        }.disabled(invoiceViewModel.isSaveInvoiceLoading || invoiceViewModel.isSendInvoiceLoading)
        .navigationBarHidden(true)
        .padding(.horizontal, 15)
        .background(Color.SCREEN_BG.ignoresSafeArea())
        .sheet(isPresented:  $showAddLineItem) {
            AddInvoiceLineItemView(invoiceViewModel: invoiceViewModel)
        }
        .onChange(of: invoiceViewModel.isSendInvoiceLoading) { isloading in
            if (invoiceViewModel.saveOrSendInvoiceSuccess == true && invoiceViewModel.errorString == nil) {
                self.showsuccessSneakBar = true
            } else if(invoiceViewModel.errorString != nil) {
                self.showErrorSneakBar = true
            }
        }
        
        .onChange(of: invoiceViewModel.isSaveInvoiceLoading) { isloading in
            if (invoiceViewModel.saveOrSendInvoiceSuccess == true && invoiceViewModel.errorString == nil) {
                self.showsuccessSneakBar = true
            } else if(invoiceViewModel.errorString != nil) {
                self.showErrorSneakBar = true
            }
        }
        .snackbar(
            show: $showsuccessSneakBar,
            snackbarType: SnackBarType.success,
            title: "Success",
            message: "Invoice Saved/Emailed SuccessFully",
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {self.presentationMode.wrappedValue.dismiss() },
            isAlignToBottom: true
        )
        .snackbar(
            show: $showErrorSneakBar,
            snackbarType: SnackBarType.error,
            title: "Error",
            message: invoiceViewModel.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: { },
            isAlignToBottom: true
        )
    }
}

