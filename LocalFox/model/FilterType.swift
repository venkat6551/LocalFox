//
//  SortingModel.swift
//  Hapag-Lloyd
//
//  Created by Meet Vora on 2022-08-26.
//

import Foundation
import SwiftUI

enum FilterType:String, Equatable {
    case none = "None"
    case quoted = "Quoted"
    case scheduled = "Scheduled"
    case completed = "Complete"
    case new = "New"
    case Invoiced = "Invoiced"
    case Assigned = "Assigned"
    
    var icon: Image {
        switch self {
        case .quoted: return Images.QUOTED_FILTER
        case .completed: return Images.COMPLETED_FILTER
        case .scheduled: return Images.SCHEDULED_FILTER
        case .new: return Images.ACTIVE_FILTER
        case .Invoiced: return Images.INVOICED_FILTER
        case .Assigned: return Images.ASSIGNED_FILTER
        case .none : return Images.ASSIGNED_FILTER
        }
    }
}

struct FilterModel: Identifiable, Equatable {
    
    var id: String {
        return type.rawValue
    }
    var type: FilterType
    var isAscending: Bool = true
    
}
