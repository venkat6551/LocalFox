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
    case quoted
    case scheduled
    case complete
    case new
    
    var text: String {
        switch self {
        case .invite: return Strings.INVITE
        case .active: return Strings.ACTIVE
        case .expired: return Strings.EXPIRED
        case .quoted: return Strings.QUOTED
        case .scheduled: return Strings.SSCHEDULED
        case .complete: return Strings.COMPLETED
        case .new: return Strings.EXPIRED
        }
    }
    
    var textColor: Color {
        switch self {
        case .invite: return Color.BLUE
        case .active: return Color.BLUE
        case .expired: return Color.BORDER_RED
        case .quoted: return Color.DARK_PURPLE
        case .scheduled: return Color.BLUE
        case .complete: return Color.TEXT_GREEN
        case .new: return Color.BORDER_RED
        }
    }
    
    var bgColor: Color {
        switch self {
        case .invite: return Color.LIGHT_BLUE
        case .active: return Color.LIGHT_BLUE
        case .expired: return Color.LIGHT_RED
        case .quoted: return Color.LIGHT_PURPLE
        case .scheduled: return Color.LIGHT_BLUE
        case .complete: return Color.LIGHT_GREEN
        case .new: return Color.LIGHT_RED
        }
    }
}



struct LeadCardView: View {
    @State var isForSearch = false
    @State var status:LeadStatus
    var onCardClick: () -> Void
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack (alignment: .top){
                    VStack {
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
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15,height: 15)
                                    }
                                    VStack (alignment: .leading, spacing: 5){
                                        Text("Marsden Park, NSW 2765")
                                            .applyFontRegular(color: Color.TEXT_LEVEL_2,size: 13)
                                        Text("Posted on 21 Jan 2022 11:45 PM")
                                            .applyFontRegular(color: Color.TEXT_LEVEL_3,size: 12)
                                    }
                                    Spacer()
                                }
                            }
                            
                        }.padding(.vertical, 5)
                        if(!isForSearch){
                            HStack (alignment: .center,spacing: 20){
                                Text(status.text).applyFontRegular(color: status.textColor, size: 12)
                                    .padding(2)
                                    .padding(.horizontal,10).cardify(cardBgColor: status.bgColor).hidden()
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
                       
                    }
                }
            }.padding(.horizontal,20)
                .padding(.vertical,20)
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
    
    private func getStatusBGColor() -> Color {
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
