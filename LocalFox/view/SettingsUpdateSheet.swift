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
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Spacer()
                    Button(
                        action: {
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            VStack {
                                Images.CLOSE
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12,height: 12)
                            } .frame(width: 34,height: 34)
                                .cardify(cardCornerRadius: 15)
                        }
                    )
                }
                Text(settingsType.text)
                    .applyFontHeader()
                Text(settingsType.subText)
                    .applyFontRegular(color: .TEXT_LEVEL_2,size: 16)
                Text(settingsType.hintText)
                    .applyFontRegular(color: .TEXT_LEVEL_3,size: 13).padding(.top,25)
                if(settingsType == .mobileNumber) {
                    MyInputTextBox(
                        text: $text,
                        keyboardType: UIKeyboardType.numberPad,
                        leadingImage: Images.FLAG,
                        leadingText: "+61"
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
                ).padding(.top, 35)
                Spacer()
            }.padding(40)
        }.background(Color.SCREEN_BG.ignoresSafeArea())
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
