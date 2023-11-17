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
    case PendingPayment = "Pending Payment" //
    case PartiallyPaid = "Partially Paid"
    case Paid = "PAID" //
    case Overdue = "Overdue"
    case Refunded = "Refunded"
    case PaymentProcessing = "Payment Processing"
    case Paymentfailed = "Payment failed"
    case Cancelled = "Cancelled"
    
    var text: String {
        switch self {
        case .Draft: return "Draft"
        case .Sent: return "Sent"
        case .PendingPayment:
            return "Pending Payment"
        case .PartiallyPaid:
            return "Partially Paid"
        case .Paid:
            return "Paid"
        case .Overdue:
            return "Overdue"
        case .Refunded:
            return "Refunded"
        case .PaymentProcessing:
            return "Payment Processing"
        case .Paymentfailed:
            return "Payment failed"
        case .Cancelled:
            return "Cancelled"
        }
    }
    
    var textColor: Color {
        switch self {
        case .Draft: return Color.BORDER_RED
        case .Sent: return Color.DARK_BLUE
       
        case .PendingPayment:
            return Color.DARK_BLUE
        case .PartiallyPaid:
            return Color.TEXT_GREEN
        case .Paid:
            return Color.BORDER_RED
        case .Overdue:
            return Color.DARK_BLUE
        case .Refunded:
            return Color.EXPIRED_RED
        case .PaymentProcessing:
            return Color.DARK_BLUE
        case .Paymentfailed:
            return Color.DARK_BLUE
        case .Cancelled:
            return Color.DARK_BLUE
        }
    }
}


struct InvoiceCardView: View {
    let invoice: InvoiceModel
    let status:QuoteStatus
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 5) {
                Text ("$\(invoice.totalPrice, specifier: "%.0f")").applyFontBold(color:Color.DEFAULT_TEXT,size: 20)
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

