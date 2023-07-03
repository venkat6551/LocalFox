//
//  ContentView.swift
//  GridViewDemo
//
//  Created by Federico on 12/03/2022.
//

import SwiftUI

struct LeadImagesView: View {
    let PHOTOS_COLOUMN_COUNT: Int = 3
    var images: [String]?
    var onJobImageClick: (String) -> Void
    var body: some View {
        
        HStack(alignment: .top,spacing: 0) {
            Images.CAMERA_ICON
                .padding(.horizontal,15)
                .padding(.vertical,18)
            
            VStack(alignment: .leading,spacing: 5){
                Text("Photos")
                    .applyFontBold(size: 15)
                VStack {
                    if let images = images {
                        if images.count > 0 {
                            WrappingHStack(alignment: .leading) {
                                ForEach(images , id: \.self) { item in
                                    
                                    
                                    Color.clear.overlay(
                                        AsyncImage(url: URL(string: item)) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()    // << for image !!
                                            default:
                                                ProgressView()
                                            }
                                        }
                                    )
                                    .frame(width: 90, height: 90, alignment: .center)
                                    .aspectRatio(1, contentMode: .fill) // << for square !!
                                    .clipped()
                                    .cardify()
                                    .onTapGesture { onJobImageClick(item) }
                                }
                            }
                        }
                        else {
                            Text("No photos added by prospective customer").applyFontRegular(color:.TEXT_LEVEL_2, size: 14)
                                .lineSpacing(5)
                        }
                    } else {
                        Text("No photos added by prospective customer").applyFontRegular(color:.TEXT_LEVEL_2, size: 14)
                            .lineSpacing(5)
                    }
                }.padding(.top,5)
            } .padding(.vertical,18)
            Spacer()
        }.cardify()
            .padding(.top,5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LeadImagesView(onJobImageClick: { image in
            
        })
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
