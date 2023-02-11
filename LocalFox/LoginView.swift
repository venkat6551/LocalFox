//
//  ContentView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/8/22.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM: LoginViewModel = LoginViewModel()
    @State private var showLeads = false
    @State private var resetPassword = false
    @State private var signUp = false
    @State private var isEmailError: Bool = false
    @State private var isPasswordError: Bool = false
    @State private var showErrorSnackbar: Bool = false
    @EnvironmentObject var authenticationStatus: AuthenticationStatus
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Spacer().frame(maxHeight: 80)
                    Images.LOCAL_FOX
                    Spacer().frame(maxHeight: 100)
                    
                    MyInputTextBox(
                        hintText: Strings.EMAIL_ADDRESS,
                        text: $loginVM.credentials.email,
                        keyboardType: UIKeyboardType.emailAddress,
                        isInputError: isEmailError
                    )
                    
                    MyInputTextBox(
                        hintText: Strings.PASSWORD,
                        text: $loginVM.credentials.password,
                        isPassword: true,
                        isInputError: isPasswordError
                    ).padding(.top,9)
                    
                    HStack(spacing: 0) {
                        Text(Strings.TC_PART1)
                            .applyFontRegular(color: Color.DEFAULT_TEXT,size: 14)
                        Text(Strings.TC_PART2)
                            .applyFontRegular(color: Color.PRIMARY,size: 14)
                    }.padding(.top, 10)
                    VStack{
                        Text(Strings.TC_PART3)
                            .applyFontRegular(color: Color.PRIMARY,size: 14)
                        MyButton(
                            text: Strings.LOGIN,
                            onClickButton: {
                                if(!loginVM.isLoading && !showErrorSnackbar) {
                                    loginVM.login { success  in
                                        authenticationStatus.setAuthenticated(authenticated: success)
                                    }
                                }
                            },
                            showLoading: loginVM.isLoading,
                            bgColor: Color.PRIMARY
                        )
                        .padding(.top, 5)
                        Spacer().frame(maxHeight: 35.0)
                        HStack {
                            Spacer()
                            Button(
                                action: {
                                    if(!loginVM.isLoading && !showErrorSnackbar) {
                                        resetPassword = true
                                    }
                                },
                                label: {
                                    Text(Strings.FORGOT_PASSWORD)
                                        .applyFontRegular(color: Color.PRIMARY,size: 14)
                                    
                                }
                            )
                        }
                        Spacer()
                        MyButton(
                            text: Strings.SIGN_UP,
                            onClickButton: {
                                if(!loginVM.isLoading && !showErrorSnackbar) {
                                    signUp = true
                                }
                            }
                        )
                        Spacer()
                            .frame(maxHeight: 44.0)
                    }
                }.padding(.horizontal, 40)
                Spacer()
                    .navigationDestination(isPresented: $showLeads) {
                        LandingView()
                    }
                    .navigationDestination(isPresented: $resetPassword) {
                        EmailAddressView()
                    }
                    .navigationDestination(isPresented: $signUp) {
                        NameView()
                    }
            }
            .background(Color.SCREEN_BG.ignoresSafeArea())
        }.navigationBarHidden(true)
            .snackbar(
                show: $showErrorSnackbar,
                snackbarType: SnackBarType.error,
                title: "Error",
                message: loginVM.errorString,
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: {showErrorSnackbar = false },
                isAlignToBottom: true
            )
            .onChange(of: loginVM.isLoading) { isloading in
                if loginVM.authenticationSuccess == true {
                    showLeads = true
                    showErrorSnackbar = false
                    isEmailError = false
                    isPasswordError = false
                } else if(loginVM.authenticationSuccess == false && loginVM.errorString != nil) {
                    showErrorSnackbar = true
                }
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
