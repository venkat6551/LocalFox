//
//  Preview.swift
//  LocalFox
//
//  Created by venkatesh karra on 01/07/23.
//

import SwiftUI

//
//  ProfileImageView.swift
//  LocalFox
//
//  Created by venkatesh karra on 28/02/23.
//

import SwiftUI
struct Preview: View {
    var imageName:String
    var totalImages: [String]?
    @State private var showErrorSnackbar: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        
        VStack(alignment: .center) {
            HStack {
                Text("Images").applyFontHeader(color: .white)
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    VStack {
                        Images.CLOSE
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12,height: 12)
                    } .frame(width: 34,height: 34)
                        .cardify(cardCornerRadius: 15)
                }
            }.padding(.horizontal,10)
                .padding(.top,10)
            GeometryReader{ geometryReader in
                if let images = totalImages {
                    InfiniteCarousel(data: images, height: geometryReader.size.height, cornerRadius: 0, transition: .opacity) { element in
                        VStack {
                            Spacer()
                            Color.clear.overlay(
                                AsyncImage(url: URL(string: imageName)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    default:
                                        ProgressView().tint(.white)
                                    }
                                }
                            )
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .clipped()
                            Spacer()
                            let index = (images.firstIndex(of: element) ?? 0) + 1
                            Text("\(index)/\(images.count) images").padding(.bottom, 10).applyFontNotes(color: .white)
                        }
                    }
                }
            }
        }.background(Color.black.ignoresSafeArea())
            .navigationBarHidden(true)
    }
}

struct Preview_Previews: PreviewProvider {
    static var previews: some View {
        Preview(imageName: "https://localfox-job-photos.s3.ap-southeast-2.amazonaws.com/jobImage_649818509660020abae6a5b2_1687689319557.jpeg", totalImages: ["https://localfox-job-photos.s3.ap-southeast-2.amazonaws.com/jobImage_649818509660020abae6a5b2_1687689319557.jpeg"])
    }
}
