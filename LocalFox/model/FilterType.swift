//
//  SortingModel.swift
//  Hapag-Lloyd
//
//  Created by Meet Vora on 2022-08-26.
//

import Foundation
import SwiftUI

enum FilterType: Equatable {
    case active
    case quoted
    case completed
    case scheduled
    case expired
    
    var text: String {
        switch self {
        case .active: return Strings.ACTIVE
        case .quoted: return Strings.QUOTED
        case .completed: return Strings.COMPLETED
        case .scheduled: return Strings.SSCHEDULED
        case .expired: return Strings.EXPIRED
        }
    }
    
    var icon: Image {
        switch self {
        case .active: return Images.ACTIVE_FILTER
        case .quoted: return Images.QUOTED_FILTER
        case .completed: return Images.COMPLETED_FILTER
        case .scheduled: return Images.SCHEDULED_FILTER
        case .expired: return Images.EXPIRED_FILTER
        }
    }
}

struct FilterModel: Identifiable, Equatable {
    
    var id: String {
        return type.text
    }
    var type: FilterType
    var isAscending: Bool = true
    
}
