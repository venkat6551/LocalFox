//
//  LeadDetailScreen.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/11/22.
//

import SwiftUI

struct LeadDetailScreen: View {
    var job:Job?
    @State private var showPhotoView = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    private let data: [Int] = Array(1...19)
    @State var selectedImage = ""
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
                    if let job = job {
                        LeadCardView(job: job, status: LeadStatus(rawValue: job.status) ?? LeadStatus.new) {
                        }.cardify()
                    }
                    
                    RowView(title: "Job location",image: Images.LOCATION_PIN, description: job?.getFormattedLocation() ?? "-")
                    RowView(title: "How soon",image: Images.TIME_ICON, description: job?.urgency ?? "-")
                    RowView(title: "Job description",image: Images.DESCRIPTION_ICON, description: job?.description ?? "-")
                    LeadImagesView(images: job?.images) { image in
                        selectedImage = image
                        self.showPhotoView = true
                    }
                }
            }.padding(.horizontal,20)
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showPhotoView) {
            Preview(imageName: selectedImage, totalImages: job?.images)
        }
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
        
        
        let job = Job(_id: nil, contact: nil, customer: nil, description: "", type: "", urgency: "", images: [], status: "", jobTitle: "", createdDate: "", lastUpdatedDate: "")
        
        LeadDetailScreen(job: job)
    }
}
