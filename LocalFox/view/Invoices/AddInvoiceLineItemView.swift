//
//  AddInvoiceLineItemView.swift
//  Local Fox
//
//  Created by venkatesh karra on 20/01/24.
//

import SwiftUI

struct AddInvoiceLineItemView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var title = ""
    @State var description  = ""
    @State var price  = ""
    @State var selectedTaxType: String? = "Tax Exclusive"
    @StateObject var invoiceViewModel: InvoiceViewModel
    @State var showErrorSnackbar = false
    var body: some View {
        VStack {
            HStack {
                Text(Strings.ADD_LINE_ITEM).applyFontHeader()
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    VStack {
                        Images.CLOSE
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12,height: 12)
                    } .frame(width: 30,height: 30)
                        .cardify(cardCornerRadius: 15)
                }
            }.padding(.top, 35).padding(.bottom, 25)
                .padding(.horizontal, 25)
            VStack (alignment: .leading){
                Text(Strings.TITLE).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16)
                TextEditor(text: $title)
                    .foregroundStyle(.secondary)
                    .cardify()
                    .frame(height: 45)
                Text(Strings.DESCRIPTION).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16).padding(.top, 20)
                TextEditor(text: $description)
                    .foregroundStyle(.secondary)
                    .cardify()
                    .frame(height: 75)
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(Strings.PRICE).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16).padding(.top, 20)
                        
                        MyInputTextBox(text: $price,keyboardType: .decimalPad, leadingImage: Images.DOLLAR)
                    }
                    VStack(alignment: .leading) {
                        Text(Strings.TAX_TYPE).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16).padding(.top, 20)
                        DropDownPicker(
                            selection: $selectedTaxType,
                            options: [
                                "Tax Exclusive",
                                "Tax Inclusive",
                                "No Tax"
                            ]
                        )
                    }
                    
                }.padding(.top, 20)
                
                Spacer()
                MyButton(text: Strings.ADD_LINE_ITEM, onClickButton: {
                    if(title.isEmpty || description.isEmpty || price.isEmpty){
                        showErrorSnackbar = true
                    }else {
                        invoiceViewModel.addLineItem(title: title, descriptiom: description, price: price, taxType: getTaxType(type: $selectedTaxType.wrappedValue ?? "No Tax"))
                        self.presentationMode.wrappedValue.dismiss()
                    }
                },  bgColor: Color.PRIMARY).padding(.top, 25)
                
            } .padding(.horizontal,25)
        }.background(Color.SCREEN_BG)
            .snackbar(
                show: $showErrorSnackbar,
                snackbarType: SnackBarType.error,
                title: "Error",
                message: "Please fill all details",
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: { },
                isAlignToBottom: true
            )
    }
    
    func getTaxType(type: String) -> String {
        if (type == "Tax Exclusive"){
            return "TAX_EXCLUSIVE"
        } else if(type == "Tax Inclusive"){
            return "TAX_INCLUSIVE"
        } else if(type == "No Tax"){
            return "NO_TAX"
        }
        return "NO_TAX"
    }
}
