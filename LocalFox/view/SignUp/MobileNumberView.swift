//
//  MobileNumberView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct MobileNumberView: View {
    @StateObject var signupVM: SignupViewModel
    @State private var mobileNumber:String = ""
    @State private var showMobileCodeView:Bool = false
    @State private var mobileNumberError: Bool = false
    @State private var showErrorSnackbar: Bool = false
    @State private var showSuccessSnackbar: Bool = false
    @FocusState private var keyboardFocused: Bool
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                MyInputTextBox(
                    hintText: Strings.MOBILE,
                    text: $signupVM.signupModel.mobileNumber,
                    keyboardType: UIKeyboardType.numberPad,
                    isInputError: mobileNumberError,
                    leadingImage: Images.FLAG,
                    leadingText: "+61",
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
                        mobileNumberError = !self.signupVM.signupModel.isValidMobileNumber
                        if !mobileNumberError {
                            if(!signupVM.isLoading && !showErrorSnackbar) {
                                signupVM.sendMobileCode { _ in
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
        .setNavTitle(Strings.MOBILE,subtitle: Strings.MOBILE_NUMBER_MESSAGE, showBackButton: true)
        .navigationDestination(isPresented: $showMobileCodeView) {
            EmailCodeView(signupVM: signupVM, isMobileVerificationCode: true, isforSignUpFlow: true) {
                
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
            onSnackbarDismissed: {showSuccessSnackbar = false },
            isAlignToBottom: true
        )
        .onChange(of: signupVM.isLoading) { isloading in
            if signupVM.sendMobileCodeSuccess == true {
                showMobileCodeView = true
                showSuccessSnackbar = true
            } else if(signupVM.sendMobileCodeSuccess == false && signupVM.errorString != nil) {
                showErrorSnackbar = true
            }
        }
    }
}

struct MobileNumberView_Previews: PreviewProvider {
    static var previews: some View {
        MobileNumberView(signupVM: SignupViewModel())
    }
}
