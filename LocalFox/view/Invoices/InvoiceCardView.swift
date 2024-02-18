//
//  InvoiceCardView.swift
//  Local Fox
//
//  Created by venkatesh karra on 17/11/23.
//

import SwiftUI
enum InvoiceStatus:String, Equatable  {
    
    case Draft = "DRAFT"
    case Sent = "SENT"
    case Paid = "PAID"
    case Overdue = "OVERDUE"
    case Due = "DUE"
    case New = "NEW"
    case Void = "VOID"
    case Deleted = "DELETED"
    
    var text: String {
        switch self {
        case .Draft: return "Draft"
        case .Sent: return "Sent"
        case .Paid: return "Paid"
        case .Overdue: return "Overdue"
        case .Void:  return "Void"
        case .Due: return "Due"
        case .New: return "New"
        case .Deleted: return "Deleted"
        }
    }
    
    var textColor: Color {
        switch self {
        case .Draft: return Color.BORDER_RED
        case .Sent: return Color.DARK_BLUE
        case .New: return Color.DARK_BLUE
        case .Paid: return Color.BORDER_RED
        case .Overdue: return Color.DARK_BLUE
        case .Due: return Color.DARK_BLUE
        case .Deleted: return Color.EXPIRED_RED
        case .Void: return Color.DARK_BLUE
        }
    }
}


struct InvoiceCardView: View {
    let invoice: InvoiceModel
    let status:QuoteStatus
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 5) {
                Text ("$\(invoice.totalPrice ?? 0, specifier: "%.0f")").applyFontBold(color:Color.DEFAULT_TEXT,size: 20)
                Text (Strings.INC_GST).applyFontBold(size: 9)
            }
            .frame(width: 97, height: 76)
            .cardify(cardBgColor: Color.BG_COLOR_1)
            .padding(10)
            VStack(alignment: .leading, spacing: 2)  {
                HStack(alignment: .center, spacing: 3) {
                    Text("•").applyFontRegular(color: status.textColor, size: 20).padding(.bottom, 2)
                    Text(status.text).applyFontRegular(color: Color.DEFAULT_TEXT, size: 12)
                }
                Text ("\(Strings.REF) \(invoice.invoiceReference)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 11)
                if let dueDate = invoice.invoiceDueDate.detailedDate {
                    Text ("\(Strings.DUE_ON) \(dueDate.replacingOccurrences(of: "on", with: ""))").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 11)
                }
                if let createdDate = invoice.createdDate.detailedDate {
                    Text ("\(Strings.CREATED) \(createdDate)").applyFontRegular(color: Color.HINT_TEXT_COLLOR,size: 11)
                }
                
            }.padding(.trailing, 10)
            Spacer()
            Images.DISCLOSURE
                .padding()
        }.frame(maxWidth: .infinity).cardify()
       
    }
}

