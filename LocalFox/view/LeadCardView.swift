//
//  LeadCardView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI


enum LeadStatus: Equatable {
    case active
    case expired
    case invite
    
    var text: String {
        switch self {
        case .invite: return Strings.INVITE
        case .active: return Strings.ACTIVE
        case .expired: return Strings.EXPIRED
        }
    }
}



struct LeadCardView: View {
    @State private var showLeadDetails = false
    @State var status:LeadStatus
    var onCardClick: () -> Void
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack (alignment: .top){
                    VStack {
                        HStack(spacing: 0) {
                            VStack{}
                                .frame(width: 8,height: 8).background(getStatusColor())
                                .cardify(borderColor: getStatusColor())
                            Text(status == LeadStatus.invite ? "Invite" : (status == LeadStatus.active ? "Active" : "Expired"))
                                .applyFontRegular(color: status == LeadStatus.invite ? Color.BLUE : Color.TEXT_LEVEL_2,size: 12)
                                .padding(.leading, 10)
                            Spacer()
                            Text("Job2423455")
                                .applyFontRegular(color: Color.TEXT_LEVEL_3,size: 10)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            VStack {
                                Images.PROFILE
                                    .foregroundColor(Color.BLUE)
                            }.frame(width: 43, height: 43 )
                                .cardify()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top){
                                    Text("Alex Eadie")
                                        .applyFontBold(size: 16)
                                    Images.GREEN_CHECK
                                        .padding(.leading, 5)
                                }
                               
                                HStack(alignment: .top){
                                    VStack{
                                        Images.LOCATION_PIN
                                            .frame(width: 15)
                                    }
                                    VStack (alignment: .leading, spacing: 5){
                                        Text("Marsden Park, NSW 2765")
                                            .applyFontRegular(color: Color.TEXT_LEVEL_2,size: 12)
                                        Text("Posted on 21 Jan 2022 11:45 PM")
                                            .applyFontRegular(color: Color.TEXT_LEVEL_3,size: 11)
                                    }
                                    Spacer()
                                }
                            }
                            
                        }.padding(.vertical, 5)
                        HStack (spacing: 20){
                            Spacer()
                            Button(
                                action: {
                                },
                                label: {
                                    Images.LOCATION_BUTTON
                                }
                            )
                            Button(
                                action: {
                                },
                                label: {
                                    Images.EMAIL_BUTTON
                                }
                            )
                            Button(
                                action: {
                                },
                                label: {
                                    Images.CALL_BUTTON
                                }
                            )
                        }
                    }
                    
//                    if (status == LeadStatus.expired) {
//                        Spacer ()
//                        VStack(spacing: 2){
//                            Text("Quote")
//                                .applyFontRegular10(color: Color.GRAY_TEXT)
//                            
//                            Text("$1349")
//                                .applyFontBold24(color: Color.BLUE)
//                            
//                            Text("Inc GST")
//                                .applyFontRegular10(color: Color.GRAY_TEXT)
//                        }.padding(.trailing, 5)
//                        
//                    }
                }
                
                
                if(status == LeadStatus.invite){
                    VStack {
                        Text("I need help to complete the rendering of my front wall and painting. I want to get his done within 4 weeks for my chirstmas.")
                            .applyFontRegular(size: 13)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(5)
                    }
                    
                    VStack (spacing: 10){
                        HStack (spacing: 5) {
                            Images.CHECKMARK
                                .frame(width: 15)
                            Text("Bathroom renovation")
                                .applyFontRegular(size: 13)
                                .padding(.leading,10)
                            Spacer()
                        }
                        
                        HStack (spacing: 5) {
                            Images.CHECKMARK
                                .frame(width: 15)
                            Text("Work to be done ASAP")
                                .applyFontRegular(size: 13)
                                .padding(.leading,10)
                            Spacer()
                        }
                        HStack (spacing: 5) {
                            Images.CHECKMARK
                                .frame(width: 15)
                            Text("Contacts verified")
                                .applyFontRegular(size: 13)
                                .padding(.leading,10)
                            Spacer()
                        }
                    }.padding(.bottom, 15)
                        .padding(.top, 10)
                    
                    HStack{
                        MyButton(
                            text: Strings.DECLINE,
                            onClickButton: { },
                            bgColor: Color.ERROR
                        ).padding(.trailing,5)
                        Spacer()
                        MyButton(
                            text: Strings.ACCEPT,
                            onClickButton: { },
                            bgColor: Color.BUTTON_GREEN
                        ).padding(.leading,5)
                    }
                }
            }.padding(20)
        }.contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .onTapGesture {
                onCardClick()
            }
    }
    
    private func getStatusColor() -> Color {
        if(status == LeadStatus.invite) {
            return Color.BLUE
        } else if(status == LeadStatus.active) {
            return Color.BUTTON_GREEN
        } else {
            return Color.PRIMARY
        }
    }
}
struct LeadCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        LeadCardView(status: LeadStatus.active) {
            
        }
    }
}
