//
//  EmailAddressView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct EmailAddressView: View {
    @StateObject var signupVM: SignupViewModel
    var isforSignUpFlow:Bool = false
    @State private var emailId:String = ""
    @State private var isEmailError: Bool = false
    @State private var showEmailCodeView:Bool = false
    @State private var showErrorSnackbar: Bool = false
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                MyInputTextBox(
                    hintText: Strings.EMAIL_ADDRESS,
                    text:  $signupVM.signupModel.email,
                    keyboardType: UIKeyboardType.emailAddress,
                    isInputError: isEmailError
                ).padding(.top,25)

                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {
                        isEmailError = !self.signupVM.signupModel.isValidEmail
                        if (isforSignUpFlow) {
                            if(!isEmailError && !signupVM.isLoading && !showErrorSnackbar) {
                                signupVM.sendEmailCode { _ in
                                }
                            }
                        } else {
                            signupVM.resetPassword(emailID: signupVM.signupModel.email) { _ in
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
            
        }.setNavTitle(Strings.EMAIL_ADDRESS,subtitle: (isforSignUpFlow ? Strings.EMAIL_ADDRESS_SUBTITLE : Strings.EMAIL_ADDRESS_SUBTITLE_RESET), showBackButton: true)
            .navigationDestination(isPresented: $showEmailCodeView) {
                EmailCodeView(signupVM: signupVM,isforSignUpFlow: isforSignUpFlow) {
                    
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
            .onChange(of: signupVM.isLoading) { isloading in                
                if(isforSignUpFlow) {
                    if signupVM.sendEmailCodeSuccess == true {
                        showEmailCodeView = true
                        showErrorSnackbar = false
                        isEmailError = false
                    } else if(signupVM.sendEmailCodeSuccess == false && signupVM.errorString != nil) {
                        showErrorSnackbar = true
                    }
                } else {
                    if signupVM.resetPasswordSuccess == true {
                        showEmailCodeView = true
                        showErrorSnackbar = false
                        isEmailError = false
                    } else if(signupVM.resetPasswordSuccess == false && signupVM.errorString != nil) {
                        showErrorSnackbar = true
                    }
                }
                
            }
            
    }
}

struct EmailAddressView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAddressView(signupVM: SignupViewModel(),isforSignUpFlow: false)
    }
}
