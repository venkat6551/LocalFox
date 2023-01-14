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
                Text(Strings.MOBILE)
                    .applyFontRegular(color: .TEXT_LEVEL_2,size: 13).padding(.top,25)
                MyInputTextBox(
                    text: $mobileNumber,
                    keyboardType: UIKeyboardType.numberPad,
                    leadingImage: Images.FLAG
                )
                MyButton(
                    text: Strings.NEXT,
                    onClickButton: {showSetPSWView = true},
                    bgColor: Color.PRIMARY
                )
                .padding(.top, 35)
                Spacer()
            }.padding(25)
            
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
