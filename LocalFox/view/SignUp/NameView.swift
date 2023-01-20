//
//  NameView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct NameView: View {
    @State private var firstName:String = ""
    @State private var lastName:String = ""
    @State private var showSetPSWView:Bool = false

    var body: some View {
        
        
        
        VStack{
            VStack(alignment: .leading,spacing: 25) {
               
                MyInputTextBox(
                    hintText: Strings.FIRST_NAME,
                    text: $firstName,
                    keyboardType: UIKeyboardType.default
                )

                MyInputTextBox(
                    hintText: Strings.LAST_NAME,
                    text: $lastName,
                    keyboardType: UIKeyboardType.default
                )
                
                VStack(alignment: .center){
                    HStack(spacing: 0) {
                        Spacer()
                        Text(Strings.TC_PART1)
                            .applyFontRegular(color: Color.DEFAULT_TEXT,size: 14)
                        Text(Strings.TC_PART2)
                            .applyFontRegular(color: Color.PRIMARY,size: 14)
                        Spacer()
                    }.padding(.top, 35)
                    Text(Strings.TC_PART3)
                        .applyFontRegular(color: Color.PRIMARY,size: 14)
                }
                
                
                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {showSetPSWView = true},
                    bgColor: Color.PRIMARY
                )
                .padding(.top, 10)
                Spacer()
            }.padding(25)
            
        }
        .setNavTitle(Strings.YOUR_NAME,subtitle: Strings.YOUR_NAME_MESSAGE, showBackButton: true)
            .navigationDestination(isPresented: $showSetPSWView) {
                MobileNumberView()
            }
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView()
    }
}
