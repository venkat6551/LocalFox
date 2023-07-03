//
//  InvitationView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/13/23.
//

import SwiftUI

struct InvitationView: View {
    
    let jobInvitation : JobInviation
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var offset = CGSize.zero

    var onCardActionClick: (Bool) -> Void
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Invitation").applyFontHeader()
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
                                .background(Color.SCREEN_BG)
                           
                        }
                    )
                }.padding(.top, 25)
                ScrollView (showsIndicators: false){
                    RowView(title: "Job location",image: Images.LOCATION_PIN, description: jobInvitation.job?.address)
                    
                    RowView(title: "How soon",image: Images.TIME_ICON, description: jobInvitation.job?.urgency)
                    
                    RowView(title: "Job description",image: Images.DESCRIPTION_ICON, description: jobInvitation.job?.description)
                    
                    LeadImagesView(images: jobInvitation.job?.images) { image in
                        
                    }
                }
               
            }.padding(.horizontal,20).background(Color.SCREEN_BG)
            HStack (spacing: 15){
                MyButton(
                    leadingImage: Images.ERROR,
                    text: Strings.DECLINE,
                    onClickButton: {
                        
                        acceptJob(accepted:false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            onCardActionClick(false)
                        }
                    },
                    bgColor: Color.PRIMARY
                ).padding(.leading,50)
                MyButton(
                    leadingImage: Images.WHITE_TICK,
                    text: Strings.ACCEPT,
                    onClickButton: {
                        acceptJob(accepted:true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            onCardActionClick(true)
                        }
                       
                    },
                    bgColor: Color.BUTTON_GREEN
                ).padding(.trailing,50)
            }
            .padding(.top,20)
            .background(Color.white)
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
        .offset(x: offset.width * 1, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))

    }
    
    func acceptJob(accepted: Bool) {
        if (accepted) {
            withAnimation {
                offset = CGSize(width: 500, height: 0)
            }
        } else {
            withAnimation {
                offset = CGSize(width: -500, height: 0)
            }
        }
    }
}

//struct InvitationView_Previews: PreviewProvider {
//    static var previews: some View {
//        InvitationView { accepted in
//            
//        }
//    }
//}
