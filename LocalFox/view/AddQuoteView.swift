//
//  AddQuoteView.swift
//  Local Fox
//
//  Created by venkatesh karra on 05/01/24.
//

import SwiftUI

struct AddQuoteView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var title = ""
    @State var descriptio  = ""
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
                TextEditor(text: $descriptio)
                                .foregroundStyle(.secondary)
                                .cardify()
                                .frame(height: 75)
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(Strings.PRICE).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16).padding(.top, 20)
                        TextEditor(text: $descriptio)
                                        .foregroundStyle(.secondary)
                                        .cardify()
                                        .frame(height: 45)
                    }
                    VStack(alignment: .leading) {
                        Text(Strings.TAX_TYPE).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16).padding(.top, 20)
                        TextEditor(text: $descriptio)
                                        .foregroundStyle(.secondary)
                                        .cardify()
                                        .frame(height: 45)
                    }
                    
                   
                }.padding(.top, 20)
                
                MyButton(text: Strings.ADD_LINE_ITEM, onClickButton: {
                    
                },  bgColor: Color.PRIMARY).padding(.top, 25)
               
                Spacer()
            } .padding(.horizontal,25)
        }.background(Color.SCREEN_BG)
    }
}

#Preview {
    AddQuoteView()
}
