//
//  ContentView.swift
//  GridViewDemo
//
//  Created by Federico on 12/03/2022.
//

import SwiftUI

struct LeadImagesView: View {
    private let data: [Int] = Array(1...20)
    
    // Flexible, custom amount of columns that fill the remaining space
    private let numberColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Adaptive, make sure it's the size of your smallest element.
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    // Fixed, creates columns with fixed dimensions
    private let fixedColumns = [
        GridItem(.fixed(150)),
        GridItem(.fixed(150))
    ]
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                
                HStack{
                    Images.CAMERA_ICON
                    .padding(10)
                    Text("Photos")
                        .applyFontBold(size: 15)
                }
                    .padding(.top, 10)
                    //.padding(.leading, 20)
                
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                        ForEach(data, id: \.self) { number in
                                Images.PROFILE
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 129, height: 112)
                        }
                    }
                }
            }
            
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LeadImagesView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
