//
//  SetPasswordView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct SetPasswordView: View {
    @StateObject var signupVM: SignupViewModel
    @State private var password:String = ""
    @State private var verifyPassword:String = ""
    @State private var showSuccessView:Bool = false
    var isforSignUpFlow:Bool = false
    @State private var showErrorSnackbar: Bool = false
    //    @State private var showSuccessSnackbar: Bool = false
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
                    onClickButton: {
                        if isforSignUpFlow {
                            if(!signupVM.isLoading && !showErrorSnackbar) {
                                signupVM.registerPArtner(password: password, confirmPassword: verifyPassword) { _ in
                                }
                            }
                        } else {
                            if(!signupVM.isLoading && !showErrorSnackbar) {
                                signupVM.setNewPassword(password: password, confirmPassword: verifyPassword, model: signupVM.signupModel) { _ in
                                }
                            }
                        }
                        
                    },
                    showLoading: signupVM.isLoading,
                    bgColor: Color.PRIMARY
                )
                .padding(.top, 35)
                Spacer()
            }.padding(.vertical,25)
                .padding(.horizontal,40)
            
        }
        .setNavTitle(Strings.SET_PASSWORD,subtitle: Strings.SET_PASSWORD_MESSAGE, showBackButton: true)
        .navigationDestination(isPresented: $showSuccessView) {
            AccountCreatedView(isResetPassword: true)
        }
        .onChange(of: signupVM.isLoading) { isloading in
            if isforSignUpFlow {
                if signupVM.registerPartnerSuccess == true {
                    showSuccessView = true
                } else if(signupVM.registerPartnerSuccess == false && signupVM.errorString != nil) {
                    showErrorSnackbar = true
                }
            } else {
                if signupVM.setNewPasswordSuccess == true {
                    showSuccessView = true
                } else if(signupVM.setNewPasswordSuccess == false && signupVM.errorString != nil) {
                    showErrorSnackbar = true
                }
            }
        }
        .snackbar(
            show: $showErrorSnackbar,
            snackbarType: SnackBarType.error,
            title: "Error",
            message: signupVM.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {showErrorSnackbar = false },
            isAlignToBottom: true
        )
    }
}

struct SetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SetPasswordView(signupVM: SignupViewModel(),isforSignUpFlow: true)
    }
}
