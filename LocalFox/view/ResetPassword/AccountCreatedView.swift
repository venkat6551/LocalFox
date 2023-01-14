//
//  AccountCreatedView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct AccountCreatedView: View {
    
    var isResetPassword:Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        NavigationUtil.popToRootView()
                    }) {
                        VStack {
                            Images.CLOSE
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12,height: 12)
                        } .frame(width: 34,height: 34)
                            .cardify(cardCornerRadius: 15)
                           
                    }
                }
                VStack (alignment: .leading) {
                    Images.CHECK_CIRCLE
                    Text(isResetPassword ? "Success" : Strings.ACCOUNT_CREATED).applyFontHeader()
                    Text(isResetPassword ? Strings.RESET_PASSWORD_SUCCESS : Strings.ACCOUNT_CREATED_MESSAGE).applyFontRegular(color: .TEXT_LEVEL_2,size: 14 )
                }.padding(.top,30)
                
                Spacer()
                MyButton(
                    text: Strings.PROCEED_TO_LOGIN,
                    onClickButton: {
                        NavigationUtil.popToRootView() 
                    },
                    bgColor: Color.PRIMARY
                )
                
            }.padding(25)
        }.background(Color.SCREEN_BG.ignoresSafeArea())
            .navigationBarHidden(true)
    }
}


struct NavigationUtil {
  static func popToRootView() {
    findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
      .popToRootViewController(animated: true)
  }

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }
}
struct AccountCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreatedView()
    }
}
