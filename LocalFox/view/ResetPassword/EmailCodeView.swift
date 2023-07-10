//
//  EmailCodeView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct EmailCodeView: View {
    @StateObject var signupVM: SignupViewModel
    @State private var code:String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showSetPSWView:Bool = false
    var isMobileVerificationCode:Bool = false
    var isforSignUpFlow:Bool = false
    @State private var showErrorSnackbar: Bool = false
    @State private var showSuccessSnackbar: Bool = false
    @FocusState private var keyboardFocused: Bool
    var onSuccess: () -> Void
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                MyInputTextBox(
                    hintText: Strings.VERIFICATION_CODE,
                    text: $code,
                    keyboardType: UIKeyboardType.numberPad,
                    isFocused:_keyboardFocused
                ).padding(.top,25)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true
                        }
                    }

                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {
                        dismissKeyboard()
                        if isMobileVerificationCode {
                            if(!signupVM.isLoading && !showErrorSnackbar) {
                                signupVM.validateMobileCode(verificationCode: code) { _ in
                                }
                            }
                        } else {
                            if(!signupVM.isLoading && !showErrorSnackbar) {
                                signupVM.validateEmailCode(verificationCode: code,context: isforSignUpFlow ? "VERIFY_EMAIL" : "RESET_PASSWORD") { _ in
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
        .setNavTitle(isMobileVerificationCode ? Strings.VERIFICATION_CODE :Strings.EMAIL_CODE,subtitle: isMobileVerificationCode ? Strings.MOBILE_VERIFICATION_MESSSAGE :Strings.EMAIL_CODE_SUBTITLE, showBackButton: true).padding(.top, isforSignUpFlow ? 0 : 30)
        .background(Color.SCREEN_BG)
        .navigationDestination(isPresented: $showSetPSWView) {
            if (isMobileVerificationCode) {
                EmailAddressView(signupVM: signupVM,isforSignUpFlow: isforSignUpFlow)
            } else {
                SetPasswordView(signupVM: signupVM, isforSignUpFlow: isforSignUpFlow)
            }
        }
        .onChange(of: signupVM.isLoading) { isloading in
            if isMobileVerificationCode {
                if signupVM.validateMobileCodeSuccess == true {
                    if (isforSignUpFlow) {
                        showSetPSWView = true
                        showSuccessSnackbar = true
                    } else {
                        if (signupVM.updateMobileNumberSuccess != true && !signupVM.isLoading) {
                            if(!signupVM.isLoading && !showErrorSnackbar) {
                                signupVM.updateMobileNumber(data: signupVM.signupModel, completion: { _ in
                                })
                            }
                        } else if (signupVM.updateMobileNumberSuccess == true && !signupVM.isLoading){
                            showSuccessSnackbar = true
                        }
                    }
                } else if(signupVM.validateMobileCodeSuccess == false && signupVM.errorString != nil) {
                    showErrorSnackbar = true
                }
            }  else {
                if signupVM.validateEmailCodeSuccess == true {
                    showSetPSWView = true
                    showSuccessSnackbar = true
                } else if(signupVM.validateEmailCodeSuccess == false && signupVM.errorString != nil) {
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
        .snackbar(
            show: $showSuccessSnackbar,
            snackbarType: SnackBarType.success,
            title: nil,
            message: signupVM.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {
                showSuccessSnackbar = false
                if(isMobileVerificationCode && !isforSignUpFlow) {
                    presentationMode.wrappedValue.dismiss()
                    onSuccess()
                } 
            },
            isAlignToBottom: true
        )
    }
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
}

struct EmailCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EmailCodeView(signupVM: SignupViewModel()) {
            
        }
    }
}
