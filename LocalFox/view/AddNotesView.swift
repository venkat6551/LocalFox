//
//  AddNotesView.swift
//  Local Fox
//
//  Created by venkatesh karra on 05/01/24.
//

import SwiftUI

struct AddNotesView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var notes = ""
    var body: some View {
        VStack {
            HStack {
                Text(Strings.ADD_JOB_NOTES).applyFontHeader()
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
                Text("Notes").applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16)
                TextEditor(text: $notes)
                                .foregroundStyle(.secondary)
                                .cardify()
                                .frame(height: 162)
                
                MyButton(text: Strings.SUBMIT, onClickButton: {
                    
                },  bgColor: Color.PRIMARY).padding(.top, 25)
               
                Spacer()
            } .padding(.horizontal,25)
        }.background(Color.SCREEN_BG)
    }
}

#Preview {
    AddNotesView()
}
