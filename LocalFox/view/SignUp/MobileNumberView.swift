//
//  MobileNumberView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct MobileNumberView: View {
    @State private var mobileNumber:String = ""
    @State private var showSetPSWView:Bool = false
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                MyInputTextBox(
                    hintText: Strings.MOBILE,
                    text: $mobileNumber,
                    keyboardType: UIKeyboardType.numberPad,
                    leadingImage: Images.FLAG,
                    leadingText: "+61"
                ).padding(.top,25)
                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {showSetPSWView = true},
                    bgColor: Color.PRIMARY
                )
                .padding(.top, 35)
                Spacer()
            }.padding(.vertical,25)
                .padding(.horizontal,40)
            
        }
        .setNavTitle(Strings.MOBILE,subtitle: Strings.MOBILE_NUMBER_MESSAGE, showBackButton: true)
        .navigationDestination(isPresented: $showSetPSWView) {
            EmailCodeView(isMobileVerificationCode: true)
        }
    }
}

struct MobileNumberView_Previews: PreviewProvider {
    static var previews: some View {
        MobileNumberView()
    }
}
