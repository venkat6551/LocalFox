//
//  SettingsUpdateSheet.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI
enum SettingsType: Equatable {
    case mobileNumber
    case address
    case pin
    
    var text: String {
        switch self {
        case .mobileNumber: return Strings.MOBILE_NUMBER
        case .address: return Strings.YOUR_ADDRESS
        case .pin: return Strings.CHANGE_PIN
        }
    }
    
    var subText: String {
        switch self {
        case .mobileNumber: return Strings.MOBILE_NUMBER_UPDATE
        case .address: return Strings.ADDRESS_UPDATE
        case .pin: return Strings.PIN_UPDATE
        }
    }
    var hintText: String {
        switch self {
        case .mobileNumber: return Strings.MOBILE_NUMBER_HINT
        case .address: return Strings.ADDRESS_UPDATE_HINT
        case .pin: return Strings.CHANGE_PIN_HINT
        }
    }
}


struct SettingsUpdateSheet: View {
    var onClickClose: () -> Void
    var settingsType: SettingsType
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(settingsType.text)
                .applyFontHeader()
            Text(settingsType.subText)
                .applyFontRegular(color: .TEXT_LEVEL_2,size: 14)
            Text(settingsType.hintText)
                .applyFontRegular(color: .TEXT_LEVEL_3,size: 13).padding(.top,25)
            if(settingsType == .mobileNumber) {
                MyInputTextBox(
                    text: $text,
                    keyboardType: UIKeyboardType.numberPad
                )
              
            } else if(settingsType == .address) {
                MyInputTextBox(
                    text: $text,
                    keyboardType: UIKeyboardType.default
                )
            } else if(settingsType == .pin) {
                MyInputTextBox(
                    text: $text,
                    keyboardType: UIKeyboardType.numberPad,
                    isPassword: true
                )
            }
            MyButton(
                text: Strings.UPDATE,
                onClickButton: {},
                bgColor: Color.PRIMARY
            )
            .padding(.top, 5)
            Spacer().frame(maxHeight: 350)
        }
    }
}

struct SettingsUpdateSheet_Previews: PreviewProvider {
    @State static private var sampleInputText: String = ""
    @State var text:String = ""
    static var previews: some View {
        SettingsUpdateSheet(onClickClose: {
            
        }, settingsType: .mobileNumber, text:$sampleInputText)
    }
}
