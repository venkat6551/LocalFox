//
//  EmailCodeView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct EmailCodeView: View {
    @State private var emailCode:String = ""
    @State private var showSetPSWView:Bool = false
    var isMobileVerificationCode:Bool = false
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                MyInputTextBox(
                    hintText: Strings.VERIFICATION_CODE,
                    text: $emailCode,
                    keyboardType: UIKeyboardType.default
                ).padding(.top,25)
                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {showSetPSWView = true},
                    bgColor: Color.PRIMARY
                )
                .padding(.top, 35)
                Spacer()
            }.padding(25)
        }
        .setNavTitle(isMobileVerificationCode ? Strings.VERIFICATION_CODE :Strings.EMAIL_CODE,subtitle: isMobileVerificationCode ? Strings.MOBILE_VERIFICATION_MESSSAGE :Strings.EMAIL_CODE_SUBTITLE, showBackButton: true)
        .navigationDestination(isPresented: $showSetPSWView) {
            if (isMobileVerificationCode) {
                EmailAddressView()
            } else {
                SetPasswordView()
            }
           
        }
    }
}

struct EmailCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EmailCodeView()
    }
}
