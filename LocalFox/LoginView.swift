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
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Spacer().frame(maxHeight: 80)
                    Images.LOCAL_FOX
                    Spacer().frame(maxHeight: 100)
                    HStack{
                        Text(Strings.EMAIL_ADDRESS)
                            .applyFontRegular(color: Color.GRAY_TEXT,size: 14)
                        Spacer()
                    }
                    MyInputTextBox(
                        hintText: "",
                        text: $loginVM.credentials.activationCode,
                        isInputError: false
                    )
                    HStack{
                        Text(Strings.PASSWORD)
                            .applyFontRegular(color: Color.GRAY_TEXT,size: 14)
                        Spacer()
                    }
                    
                    .padding(.top,9)
                    MyInputTextBox(
                        hintText: "",
                        text: $loginVM.credentials.activationCode,
                        isPassword: true,
                        isInputError: false
                    )
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
                            onClickButton: { showLeads = true},
                            bgColor: Color.PRIMARY
                        )
                        .padding(.top, 5)
                        Spacer().frame(maxHeight: 35.0)
                        HStack {
                            Spacer()
                            Text(Strings.FORGOT_PASSWORD)
                                .applyFontRegular(color: Color.PRIMARY,size: 14)
                        }
                        Spacer()
                        MyButton(
                            text: Strings.SIGN_UP,
                            onClickButton: { }
                        )
                        Spacer()
                            .frame(maxHeight: 44.0)
                    }
                }.padding(.horizontal, 25)
                Spacer()
                    .navigationDestination(isPresented: $showLeads) {
                        LandingView()
                    }
            }
            
            .background(Color.SCREEN_BG.ignoresSafeArea())
        }.navigationBarHidden(true)
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
