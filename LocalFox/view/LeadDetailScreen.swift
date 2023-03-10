//
//  LeadDetailScreen.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/11/22.
//

import SwiftUI

struct LeadDetailScreen: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    private let data: [Int] = Array(1...19)

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Job Details").applyFontHeader()
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
                    LeadCardView(status: LeadStatus.active,onCardClick:{}).cardify()
            
                    RowView(title: "Job location",image: Images.LOCATION_PIN, description: "Marsden Park, NSW 2765")
                    
                    RowView(title: "How soon",image: Images.TIME_ICON, description: "In next couple of weeks")
                    
                    RowView(title: "Job description",image: Images.DESCRIPTION_ICON, description: "We need a flooring to be done by end of this month at Marsden Park.\n\n There are some broken tiles in couple of bedrooms. Those need to be replaced with new and also install the new tiles in master bedroom. 16sqm.")
                    LeadImagesView()
                }
            }.padding(.horizontal,20)
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
}
struct RowView: View {
    var title: String
    var image: Image?
    var description: String?
    var body: some View {
            HStack(alignment: .top,spacing: 0) {
                if let image = image {
                    image
                        .padding(.horizontal,15)
                        .padding(.vertical,18)
                }
                
            VStack(alignment: .leading,spacing: 5){
                Text(title)
                    .applyFontBold(size: 15)
                if let description = description {
                    Text(description)
                        .applyFontRegular(color:.TEXT_LEVEL_2, size: 14)
                        .lineSpacing(5)
                }
            } .padding(.vertical,18)
            Spacer()
        }.cardify()
            .padding(.top,5)
        
    }
}
struct LeadDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        LeadDetailScreen()
    }
}
