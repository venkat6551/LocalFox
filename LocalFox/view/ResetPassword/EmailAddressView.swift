//
//  EmailAddressView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct EmailAddressView: View {
    @StateObject private var resetPSWVM: ResetPSWViewModel = ResetPSWViewModel()
    @State private var emailId:String = ""
    @State private var isEmailError: Bool = false
    @State private var showEmailCodeView:Bool = false
    @State private var showErrorSnackbar: Bool = false
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                MyInputTextBox(
                    hintText: Strings.EMAIL_ADDRESS,
                    text: $emailId,
                    keyboardType: UIKeyboardType.emailAddress
                ).padding(.top,25)
                
                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {showEmailCodeView = true},
                    bgColor: Color.PRIMARY
                )
                .padding(.top, 35)
                Spacer()
            }.padding(.vertical,25)
                .padding(.horizontal,40)
            
        }.setNavTitle(Strings.EMAIL_ADDRESS,subtitle: Strings.EMAIL_ADDRESS_SUBTITLE, showBackButton: true)
            .navigationDestination(isPresented: $showEmailCodeView) {
            EmailCodeView()
        }
            .snackbar(
                show: $showErrorSnackbar,
                snackbarType: SnackBarType.error,
                title: resetPSWVM.error?.title,
                message: resetPSWVM.error?.description,
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: {showErrorSnackbar = false },
                isAlignToBottom: true
            )
            .onChange(of: resetPSWVM.isLoading) { isloading in
//                if resetPSWVM.resetPasswordSuccess == true {
//                    showEmailCodeView = true
//                    showErrorSnackbar = false
//                    isEmailError = false
//                } else if(resetPSWVM.resetPasswordFailed == true && resetPSWVM.error?.title != nil) {
//                    showErrorSnackbar = true
//                }
//                switch resetPSWVM.error {
//                case .invalidEmail:
//                    isEmailError = true
//                case .invalidCredentials:
//                    isEmailError = true
//                case .authenticationFail:
//                    // TODO: Auth failed UI
//                    break
//                case .none: break
//                }
            }
            
    }
}

struct EmailAddressView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAddressView()
    }
}
