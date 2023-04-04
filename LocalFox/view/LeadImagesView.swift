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
    //private let data: [Int] = Array(1...19)
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
                            let rowCount:Int = ((images.count % PHOTOS_COLOUMN_COUNT == 0) ? (images.count/PHOTOS_COLOUMN_COUNT) : (images.count/PHOTOS_COLOUMN_COUNT + 1))
                            ForEach(0..<rowCount, id:\.self) { i in
                                let v:Int = rowCount - 1
                                if(i == v && images.count % PHOTOS_COLOUMN_COUNT != 0) {
                                    HStack(){
                                        ForEach(0..<images.count % PHOTOS_COLOUMN_COUNT, id:\.self) { j in
                                            Images.PROFILE
                                                .resizable()
                                                .scaledToFill()
                                        }
                                        // addd dummy images just to fill the gap
                                        ForEach(0..<PHOTOS_COLOUMN_COUNT-images.count % PHOTOS_COLOUMN_COUNT, id:\.self) { j in
                                            Images.PROFILE
                                                .resizable()
                                                .scaledToFill().hidden()
                                        }
                                    }
                                } else {
                                    HStack{
                                        ForEach(0..<3) { j in
                                            // Text("V:\(i*PHOTOS_COLOUMN_COUNT + j)")
                                            
                                            AsyncImage(
                                                url: URL(string:"https://localfox-partner-profile-images.s3.ap-southeast-2.amazonaws.com/partnerProfile_63ed09a72f42c1154430e776_1680374128487.png")!,
                                                placeholder: { Text("Loading ...") },
                                                image: { Image(uiImage: $0).resizable() }
                                            ).frame(width: 100, height: 80, alignment: .center)
                                        }
                                    }
                                }
                            }
                        } else {
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
        LeadImagesView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
