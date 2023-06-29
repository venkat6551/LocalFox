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
    @StateObject var profileVM: ProfileViewModel
    @StateObject private var signupVM: SignupViewModel = SignupViewModel()
    @State private var showOTPCodeView:Bool = false
    @State private var showErrorSnackbar: Bool = false
    @State private var showSuccessSnackbar: Bool = false
    @State private var addressSelected: Bool = false
    @State private var addressList: [String] = []
    var onUpdateSuccess: () -> Void
    var settingsType: SettingsType
    @Binding var text: String
    @State var autocompleteResults :[GApiResponse.Autocomplete] = []
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationStack {
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
                            text: $signupVM.signupModel.mobileNumber,
                            keyboardType: UIKeyboardType.numberPad,
                            leadingImage: Images.FLAG,
                            leadingText: "+61"
                        )
                    } else if(settingsType == .address) {
                            MyInputTextBox(
                                text: $text,
                                keyboardType: UIKeyboardType.default
                            )
                            if autocompleteResults.count > 0 {
                                AddressesView(addressList: $addressList) { selectedAddress in
                                    text = selectedAddress
                                    addressList.removeAll()
                                    addressList.removeAll()
                                    addressSelected = true
                                }
                            }
                        } else if(settingsType == .pin) {
                            MyInputTextBox(
                                text: $text,
                                keyboardType: UIKeyboardType.numberPad,
                                isPassword: true
                            )
                        }
                        
                        MyButton(
                            text: Strings.UPDATE,
                            onClickButton: {
                                if(settingsType == .mobileNumber) {
                                    signupVM.sendMobileCode { _ in
                                    }
                                } else if(settingsType == .address) {
                                    profileVM.updateAddress(_withAddress: text)
                                }
                            },
                            showLoading: (settingsType == .address) ? profileVM.isLoading : signupVM.isLoading,
                            bgColor: Color.PRIMARY
                        ).padding(.top, 35)
                        Spacer()
                    }.padding(40)
                }.background(Color.SCREEN_BG.ignoresSafeArea())
                .ignoresSafeArea(.keyboard, edges: .bottom)
                    .navigationDestination(isPresented: $showOTPCodeView) {
                        EmailCodeView(signupVM: signupVM,isMobileVerificationCode: true) {
                            profileVM.profileModel?.data?.mobileNumber = text
                            self.presentationMode.wrappedValue.dismiss()
                            onUpdateSuccess()
                        }
                    }
                    .onChange(of: signupVM.isLoading || profileVM.isLoading) { isloading in
                        if(settingsType == .mobileNumber) {
                            if signupVM.sendMobileCodeSuccess == true {
                                showOTPCodeView = true
                                showErrorSnackbar = false
                            } else if(signupVM.sendMobileCodeSuccess == false && signupVM.errorString != nil) {
                                showErrorSnackbar = true
                            }
                        }
                        if(settingsType == .address) {
                            if profileVM.editAddressSuccess == true {
                                showSuccessSnackbar = true
                            } else if(profileVM.editAddressSuccess == false && signupVM.errorString != nil) {
                                showErrorSnackbar = true
                            }
                        }
                    }.onChange(of: text) { text in
                        if(!addressSelected) {
                            if (text.count > 3) {
                                var input = GInput()
                                input.keyword = text
                                GoogleApi.shared.callApi(input: input) { (response) in
                                    if response.isValidFor(.autocomplete) {
                                        DispatchQueue.main.async {
                                            autocompleteResults.removeAll()
                                            addressList.removeAll()
                                            autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                                            var ary:[String] = []
                                            for autocompleteResult in autocompleteResults  {
                                                ary.append(autocompleteResult.formattedAddress)
                                            }
                                            addressList = ary
                                        }
                                    } else {
                                        autocompleteResults.removeAll()
                                        addressList.removeAll()                                        
                                    }
                                }
                            }
                        }
                        addressSelected = false
                    }
                    .onAppear{
                        signupVM.signupModel.mobileNumber = text;
                        signupVM.signupModel.firstName = profileVM.profileModel?.data?.firstName ?? ""
                    }
                    .snackbar(
                        show: $showErrorSnackbar,
                        snackbarType: SnackBarType.error,
                        title: "Error",
                        message: (settingsType == .address) ? profileVM.errorString : signupVM.errorString,
                        secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                        onSnackbarDismissed: {showErrorSnackbar = false },
                        isAlignToBottom: true
                    )
                    .snackbar(
                        show: $showSuccessSnackbar,
                        snackbarType: SnackBarType.success,
                        title: nil,
                        message: (settingsType == .address) ? profileVM.errorString : signupVM.errorString,
                        secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                        onSnackbarDismissed: {
                            if(settingsType == .address){
                                profileVM.profileModel?.data?.location = Location(type: nil, streetName: text)
                                self.presentationMode.wrappedValue.dismiss()
                                onUpdateSuccess()
                            }
                            showSuccessSnackbar = false
                        },
                        isAlignToBottom: true
                    )
            }
        }
    }
    
    struct AddressesView: View {
        @Binding var addressList: [String]
        var onChangeEnvironment: (String) -> Void
        var body: some View {
            VStack(spacing: 0) {
                if addressList.count > 0 {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(addressList, id: \.self) { address in
                                AddressRow(address: address) {
                                    changeAddress(address: address)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        struct AddressRow: View {
            var address : String
            var onClick: () -> Void
            
            private let LEADING_ICON_SIZE: CGFloat = 20
            private let ROW_INNER_SPACING: CGFloat = 12
            
            var body: some View {
                Button(action: {
                    onClick()
                }, label: {
                    HStack(spacing: ROW_INNER_SPACING) {
                        Text(address)
                            .applyFontText()
                            .padding(.leading, 10)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(Color.white )
                    .cornerRadius(5)
                })
            }
        }
        
        private func changeAddress(address:String) {
            onChangeEnvironment(address)
        }
    }
    
    
    struct SettingsUpdateSheet_Previews: PreviewProvider {
        @State static private var sampleInputText: String = ""
        @State var text:String = ""
        static var previews: some View {
            SettingsUpdateSheet(onClickClose: {
                
            }, profileVM: ProfileViewModel(), onUpdateSuccess: {
            }, settingsType: .mobileNumber, text:$sampleInputText)
        }
    }
