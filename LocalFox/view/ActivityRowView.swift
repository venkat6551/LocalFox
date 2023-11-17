//
//  ActivityRowView.swift
//  Local Fox
//
//  Created by venkatesh karra on 17/11/23.
//

import SwiftUI

enum ActivityType : String, Equatable {
    case call = "CALL"
    case quote = "QUOTE"
    case notes = "NOTES"
    case sms = "SMS"
    case paymentReceived = "PAYMENT"//
    case scheduled = "SCHEDULED" //
    case complete = "COMPLETE" //
    case invoice = "INVOICE"
    case none = "NONE"
    
    var image: Image {
        switch self {
        case .call :
            return Images.CALL_ACT_ICON
        case .quote:
            return Images.QUOTE_ACT_ICON
        case .notes:
            return Images.NOTES_ACT_ICON
        case .sms:
            return Images.CALL_ACT_ICON //
        case .paymentReceived:
            return Images.PAYMENT_ACT_ICON
        case .scheduled:
            return Images.SCHEDULE_ACT_ICON
        case .complete:
            return Images.COMPLETE_ACT_ICON
        case .invoice:
            return Images.CALL_ACT_ICON //
        case .none:
            return Images.CALL_ACT_ICON
        }
    }
    
}

struct ActivityRowView: View {
    var activity: ActivityModel
    var activityType: ActivityType
    var body: some View {
        HStack(alignment: .top){
            HStack {
                activityType.image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipped()
            } .frame(width: 45, height: 45)
                .cardify(borderColor:.clear, cardCornerRadius: 19)
                .padding(.trailing, 15)
                .padding(.leading, 8)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text ("\(activity.createdDate.detailedDate? .replacingOccurrences(of: "on", with: "") ?? "")").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 10)
                    Spacer()
                }
                HStack {
                    Text (activity.activityDescription).applyFontRegular(color: Color.DISABLED_TEXT,size: 14).multilineTextAlignment(.leading)
                   
                    if(activityType == .paymentReceived) {
                        Spacer()
                        Text("PAID").applyFontBold(color:Color.TEXT_GREEN,size: 18)
                    }
                }
                
                if(activityType == .notes) {
                    if let notes = activity.notes
                    {
                        Text (notes).applyFontRegular(color: Color.DISABLED_TEXT,size: 11).multilineTextAlignment(.leading)
                    }
                }
                
                switch activityType {
                case .quote:
                    HStack {
                        Button(action: {}, label: {
                            Text(Strings.VIEW_QUOTE).applyFontRegular(color:Color.blue, size: 11)
                        })
                        Spacer()
                        let quote = activity.quote?.totalPrice ?? 0
                        Text("$\(quote, specifier:"%.0f")").applyFontBold(color:Color.blue,size: 18)
                        Text(Strings.INC_GST).applyFontBold(size: 9)
                    }

                case .paymentReceived:
                    EmptyView()
                case .scheduled:
                    HStack{
                        Button(action: {}, label: {
                            Text("Reschedule").applyFontRegular(color:Color.blue, size: 11)
                        })
                    }
                default:
                    VStack {
                    
                    }
                }
                
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .cardify()
        }
    }
}
