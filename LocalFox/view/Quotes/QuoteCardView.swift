//
//  QuoteCardView.swift
//  Local Fox
//
//  Created by venkatesh karra on 15/11/23.
//

import SwiftUI

enum QuoteStatus:String, Equatable  {
    
    case Draft = "DRAFT"
    case Sent = "SENT"
    case Accepted = "ACCEPTED"
    case Expired = "EXPIRED"
    case Invoiced = "INVOICED"
    case Void = "VOID"
    
    var text: String {
        switch self {
        case .Draft: return "Draft"
        case .Sent: return "Sent"
        case .Accepted: return "Accepted"
        case .Expired: return "Expired"
        case .Invoiced: return "Invoiced"
        case .Void: return "Void"
        }
    }
    
    var textColor: Color {
        switch self {
        case .Draft: return Color.BORDER_RED
        case .Sent: return Color.DARK_BLUE
        case .Accepted: return Color.TEXT_GREEN
        case .Expired: return Color.EXPIRED_RED
        case .Invoiced: return Color.DARK_BLUE
        case .Void: return Color.DARK_BLUE
        }
    }
    
    var bgColor: Color {
        switch self {
        case .Draft: return Color.LIGHT_RED
        case .Sent: return Color.LIGHT_BLUE
        case .Accepted: return Color.LIGHT_GREEN
        case .Expired: return Color.LIGHT_RED
        case .Invoiced: return Color.LIGHT_BLUE
        case .Void: return Color.LIGHT_BLUE
        }
    }
}

struct QuoteCardView: View {
    let quote: QuoteModel
    let status:QuoteStatus
    var body: some View {
        
        HStack {
            VStack(alignment: .leading,spacing: 5) {
                Text ("$\(quote.totalPrice ?? 0, specifier: "%.0f")").applyFontBold(color:Color.DEFAULT_TEXT,size: 20)
                Text (Strings.INC_GST).applyFontBold(size: 9)
            }
            .frame(width: 97, height: 86)
            .cardify(cardBgColor: Color.BG_COLOR_1)
            .padding(10)
            VStack(alignment: .leading, spacing: 5)  {
                HStack(alignment: .center, spacing: 3) {
                    Text("•").applyFontRegular(color: status.textColor, size: 20).padding(.bottom, 2)
                    Text(status.text).applyFontRegular(color: status.textColor, size: 12)
                        .padding(.vertical, 2)
                        .padding(.trailing, 10)
                }
                Text ("\(Strings.QUOTE) \(quote.quoteReference)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 11)
                if let createdDate = quote.createdDate.detailedDate {
                    Text ("\(Strings.CREATED) \(createdDate)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 11)
                }
                
            }.padding(.trailing, 10)
            Spacer()
            Images.DISCLOSURE
                .padding()
        }.frame(maxWidth: .infinity).cardify()
       
    }
}

