//
//  NameView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct NameView: View {
    @StateObject private var signupVM: SignupViewModel = SignupViewModel()
    @State private var firstNameError: Bool = false
    @State private var lastNameError: Bool = false
    @State private var showMobileNumberView:Bool = false
    @FocusState private var keyboardFocused: Bool
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                VStack(alignment: .leading,spacing: 25) {
                    MyInputTextBox(
                        hintText: Strings.FIRST_NAME,
                        text: $signupVM.signupModel.firstName,
                        keyboardType: UIKeyboardType.default,
                        isInputError: firstNameError,
                        isFocused:_keyboardFocused
                    ).onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true
                        }
                    }
                    MyInputTextBox(
                        hintText: Strings.LAST_NAME,
                        text: $signupVM.signupModel.lastName,
                        keyboardType: UIKeyboardType.default,
                        isInputError: lastNameError
                    )
                }
                
                VStack(alignment: .center){
                    TermsAndConditionsTextView()
                }.padding(.top, 10)
                
                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {
                        self.firstNameError = !signupVM.signupModel.isValidFirstName
                        self.lastNameError = !signupVM.signupModel.isValidLastName
                        if(signupVM.signupModel.isValidFirstName && signupVM.signupModel.isValidLastName){
                            showMobileNumberView = true
                        }
                    },
                    bgColor: Color.PRIMARY
                ).padding(.top,5)
                Spacer()
            }.padding(.vertical,25)
                .padding(.horizontal,40)
        }
        .setNavTitle(Strings.YOUR_NAME,subtitle: Strings.YOUR_NAME_MESSAGE, showBackButton: true)
        .navigationDestination(isPresented: $showMobileNumberView) {
            MobileNumberView(signupVM: signupVM)
        }
    }
}


struct TermsAndConditionsTextView: View {
    var body: some View {
        VStack {
            Group() {
                let privacyPolicyText = "\(Strings.TC_PART1_REG) [terms and conditions](\(Strings.TERMS_LINK)) and [\(Strings.PRIVACY)](\(Strings.PRIVACY_LINK))"
                Text(.init(privacyPolicyText))
            }
            .multilineTextAlignment(.center)
            .applyFontRegular(color: Color.DEFAULT_TEXT,size: 14)
            .accentColor(Color.PRIMARY)
        }
    }
}


struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView()
    }
}
