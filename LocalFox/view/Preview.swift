//
//  Preview.swift
//  LocalFox
//
//  Created by venkatesh karra on 01/07/23.
//

import SwiftUI
import Nuke
import NukeUI

struct Preview: View {
    var imageName:String
    var totalImages: [String]?
    @State private var showErrorSnackbar: Bool = false
    @State private var currentImageIndex: Int = 1
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
                    
                    ZStack (alignment: .bottom) {
                        
                        InfiniteCarousel(data: images, height: geometryReader.size.height, cornerRadius: 0, transition: .opacity) { element in
                            VStack(alignment: .center) {
                                Spacer()
                                GeometryReader { proxy in
                                    let frame = proxy.frame(in: .local)
                                    LazyImage(url: URL(string: element), transaction: Transaction(animation: .linear)) { state in
                                        if let image = state.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: frame.width, height: frame.height)
                                                .clipped()
                                        } else {
                                            VStack(alignment: .center) {
                                                Spacer()
                                                HStack{
                                                    Spacer()
                                                    ProgressView().tint(.white)
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                    .priority(.high)
                                    .pipeline(pipeline)
                                }
                                Spacer()
                                let index = (images.firstIndex(of: element) ?? 0) + 1
                                Text("\(index)/\(images.count)")
                                    .padding(.bottom, 10)
                                    .applyFontMedium(color: .white, size: 14)
                                    .onAppear{
                                        currentImageIndex = index
                                    }
                            }
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

public let pipeline = ImagePipeline {
    $0.dataLoader = DataLoader(configuration: {
        let conf = DataLoader.defaultConfiguration
        conf.urlCache = nil
        return conf
    }())
    $0.dataCache = try? DataCache(name: "app.wheretogo")
}
