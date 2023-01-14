//
//  EmailAddressView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct EmailAddressView: View {
    @State private var emailId:String = ""
    @State private var showEmailCodeView:Bool = false
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text(Strings.EMAIL_ADDRESS)
                    .applyFontRegular(color: .TEXT_LEVEL_2,size: 13).padding(.top,25)
                MyInputTextBox(
                    text: $emailId,
                    keyboardType: UIKeyboardType.emailAddress
                )
                
                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {showEmailCodeView = true},
                    bgColor: Color.PRIMARY
                )
                .padding(.top, 35)
                Spacer()
            }.padding(25)
            
        }.setNavTitle(Strings.EMAIL_ADDRESS,subtitle: Strings.EMAIL_ADDRESS_SUBTITLE, showBackButton: true)
            .navigationDestination(isPresented: $showEmailCodeView) {
            EmailCodeView()
        }
            
    }
}

struct EmailAddressView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAddressView()
    }
}
