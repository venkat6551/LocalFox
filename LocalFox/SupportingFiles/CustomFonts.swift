//
//  CustomFonts.swift
//  Hapag-Lloyd
//
//  Custom font style extension for Text
//
//  Created by Meet Vora on 2022-07-15.
//

import Foundation
import SwiftUI

// Sets custom font and color - Inter
extension View {
        
//    func applyFontRegular10(color: Color = Color.DEFAULT_TEXT) -> some View {
//        return self.font(Font.custom("Inter-Regular", size: 10))
//            .foregroundColor(color)
//    }
//    func applyFontRegular11(color: Color = Color.DEFAULT_TEXT) -> some View {
//        return self.font(Font.custom("Inter-Regular", size: 11))
//            .foregroundColor(color)
//    }
//    func applyFontRegular12(color: Color = Color.DEFAULT_TEXT) -> some View {
//        return self.font(Font.custom("Inter-Regular", size: 12))
//            .foregroundColor(color)
//    }
//    func applyFontRegular13(color: Color = Color.DEFAULT_TEXT) -> some View {
//        return self.font(Font.custom("Inter-Regular", size: 13))
//            .foregroundColor(color)
//    }
//    func applyFontRegular14(color: Color = Color.DEFAULT_TEXT) -> some View {
//        return self.font(Font.custom("Inter-Regular", size: 14))
//            .foregroundColor(color)
//    }
//
//    func applyFontRegular16(color: Color = Color.DEFAULT_TEXT) -> some View {
//        return self.font(Font.custom("Inter-Regular", size: 16))
//            .foregroundColor(color)
//    }
    
    func applyFontRegular(color: Color = Color.DEFAULT_TEXT, size: CGFloat) -> some View {
        return self.font(Font.custom("Inter-Regular", size: size))
            .foregroundColor(color)
    }
    
    func applyFontBold(color: Color = Color.DEFAULT_TEXT, size: CGFloat) -> some View {
        return self.font(Font.custom("Inter-Bold", size: size))
            .foregroundColor(color)
    }
 
    
    func applyFontTitle(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Regular", size: 24))
            .foregroundColor(color)
    }
    
    func applyFontHeader(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Bold", size: 28))
            .foregroundColor(color)
    }
    
    func applyFontHeaderMedium(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Medium", size: 24))
            .foregroundColor(color)
    }
    
    func applyFontMedium(color: Color = Color.DEFAULT_TEXT, size: CGFloat) -> some View {
        return self.font(Font.custom("Inter-Medium", size: size))
            .foregroundColor(color)
    }
    
    
    func applyFontBodyMedium(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Medium", size: 20).bold())
            .foregroundColor(color)
    }
    
    func applyFontSubheading(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Regular", size: 18))
            .foregroundColor(color)
    }
    
    func applyFontSubheadingMedium(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Medium", size: 18))
            .foregroundColor(color)
    }
    
    func applyFontText(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Regular", size: 16))
            .foregroundColor(color)
    }
    
    func applyFontTextMedium(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Medium", size: 16))
            .foregroundColor(color)
    }
    
    func applyFontNotes(color: Color = Color.DEFAULT_TEXT) -> some View {
        return self.font(Font.custom("Inter-Regular", size: 16))
            .foregroundColor(color)
    }
    
}

struct CustomFonts_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("Title").applyFontTitle()
                        Text("Header").applyFontHeader()
                        Text("HeaderMedium").applyFontHeaderMedium()
                        Text("Body").applyFontRegular(size: 16)
                        Text("BodyMedium").applyFontBodyMedium()
                        Text("Subheading").applyFontSubheading()
                        Text("SubheadingMedium").applyFontSubheadingMedium()
                        Text("Text").applyFontText()
                        Text("TextMedium").applyFontTextMedium()
                        Text("Notes").applyFontNotes()
                    }
                    Divider()
                    // If you add any font TTF file, below for-loop should automatically list it.
                    // If it doesn't list your TTF, then something is wrong with mapping from xCode with your file.
                    ForEach(UIFont.familyNames, id: \.self) { familyName in
                        if familyName == "Inter" {
                            Text(familyName).applyFontHeader()
                            ForEach(UIFont.fontNames(forFamilyName: familyName), id: \.self) { fontName in
                                Text("= \(fontName)").applyFontNotes()
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .previewDevice("iPhone Xs")
    }
}
