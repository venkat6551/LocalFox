//
//  SetPasswordView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct SetPasswordView: View {
    @State private var password:String = ""
    @State private var verifyPassword:String = ""
    @State private var showSetPSWView:Bool = false
    var body: some View {
        VStack{
            VStack(alignment: .leading,spacing: 25) {

                MyInputTextBox(
                    hintText: Strings.NEW_PASSWORD,
                    text: $password,
                    keyboardType: UIKeyboardType.default,
                    isPassword: true
                )

                MyInputTextBox(
                    hintText: Strings.CONFIRM_PASSWORD,
                    text: $verifyPassword,
                    keyboardType: UIKeyboardType.default,
                    isPassword: true
                )
                
                MyButton(
                    text: Strings.RESET_PASSWORD,
                    onClickButton: {showSetPSWView = true},
                    bgColor: Color.PRIMARY
                )
                .padding(.top, 35)
                Spacer()
            }.padding(.vertical,25)
                .padding(.horizontal,40)
            
        }
        .setNavTitle(Strings.SET_PASSWORD,subtitle: Strings.SET_PASSWORD_MESSAGE, showBackButton: true)
    
            .navigationDestination(isPresented: $showSetPSWView) {
                AccountCreatedView(isResetPassword: true)
            }
    }
}

struct SetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SetPasswordView()
    }
}
