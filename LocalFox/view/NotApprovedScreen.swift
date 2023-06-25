//
//  NotApprovedScreen.swift
//  LocalFox
//
//  Created by venkatesh karra on 08/05/23.
//

import SwiftUI
struct NotApprovedScreen: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var profileVM: ProfileViewModel
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Spacer().frame(maxHeight: 30)
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            label: {
                                VStack {
                                    Images.LOGOUT
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16,height: 16)
                                } .frame(width: 34,height: 34)
                                    .cardify(cardCornerRadius: 15)
                                    .background(Color.SCREEN_BG)
                            }
                        )
                    }
                    
                    HStack{
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Text("Welcome, ").applyFontHeader()
                                Text(profileVM.profileModel?.data?.firstName ?? "").applyFontHeader()
                            }
                            Text("In Review").applyFontBold(color: Color.PRIMARY,size: 16)
                        }
                        Spacer()
                    }
                    
                    Details()
                }.padding(.horizontal, 40)
                Spacer()
                
            }
            .background(Color.SCREEN_BG.ignoresSafeArea())
        }.navigationBarHidden(true)
        
        
    }
}

struct Details: View {
    var body: some View {
        HStack(alignment: .top,spacing: 0) {
            Images.INFO_ICON
                .padding(.horizontal,15)
                .padding(.vertical,18)
            
            VStack(alignment: .leading,spacing: 5){
                Text("Application in review").applyFontBold(size: 15).padding(.bottom, 10)
                Text("We are reviewing your details to onboard you with Local Fox. We will get back to you as soon as possible.\n\nPlease do not hesitate to write us if you have any questions: partner@localfox.com.au")
                    .applyFontRegular(color:.TEXT_LEVEL_2, size: 15)
                    .accentColor(Color.BLUE)
                    .lineSpacing(5)
            } .padding(.vertical,18)
            Spacer()
        }.cardify()
            .padding(.top,5)
        
    }
}

struct NotApprovedScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotApprovedScreen(profileVM: ProfileViewModel())
    }
}
