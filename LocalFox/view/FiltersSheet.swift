//
//  FiltersSheet.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/13/23.
//

import SwiftUI

struct FiltersSheet: View {
    
    var onClickClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            RowView(title: "Job location",image: Images.LOCATION_PIN, description: "Marsden Park, NSW 2765")
            RowView(title: "Job location",image: Images.LOCATION_PIN, description: "Marsden Park, NSW 2765")
            RowView(title: "Job location",image: Images.LOCATION_PIN, description: "Marsden Park, NSW 2765")
        }
    }
}

struct FiltersSheet_Previews: PreviewProvider {
    static var previews: some View {
        FiltersSheet {
            
        }
    }
}
