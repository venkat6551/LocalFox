//
//  ContentView.swift
//  GridViewDemo
//
//  Created by Federico on 12/03/2022.
//

import SwiftUI

struct LeadImagesView: View {
    private let data: [Int] = Array(1...19)
    var body: some View {
        
        HStack(alignment: .top,spacing: 0) {
            Images.CAMERA_ICON
                .padding(.horizontal,15)
                .padding(.vertical,18)
            
            VStack(alignment: .leading,spacing: 5){
                Text("Photos")
                    .applyFontBold(size: 15)
                VStack {
                    let rowCount:Int = ((data.count % 3 == 0) ? (data.count/3) : (data.count/3 + 1))
                    ForEach(0..<rowCount, id:\.self) { i in
                        let v:Int = rowCount - 1
                        if(i == v && data.count % 3 != 0) {
                            HStack(){
                                ForEach(0..<data.count % 3, id:\.self) { j in
                                    Images.PROFILE
                                        .resizable()
                                        .scaledToFill()
                                }
                                ForEach(0..<3-data.count % 3, id:\.self) { j in
                                    Images.PROFILE
                                        .resizable()
                                        .scaledToFill().hidden()
                                }
                            }
                        } else {
                            HStack{
                                ForEach(0..<3) { j in
                                    Images.PROFILE
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                        }
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
