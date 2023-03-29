//
//  SearchView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var searchText: String = ""
    @FocusState private var keyboardFocused: Bool
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Search Leads").applyFontHeader()
                    Spacer()
                    Button(
                        action: {
                            self.presentationMode.wrappedValue.dismiss() // Go back
                        },
                        label: {
                            Images.ERROR
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18)
                                .foregroundColor(Color.BLUE)
                        }
                    )
                }
                
                MySearchBox(
                    hintText: Strings.SEARCH,
                    text: $searchText,
                    isFocused:_keyboardFocused
                ).padding(.bottom, 15)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true
                        }
                    }
                ScrollView (showsIndicators: false){
                    
//                    LeadCardView(isForSearch: true, status: LeadStatus.active,onCardClick:{}).cardify()
//                    LeadCardView(isForSearch: true,status: LeadStatus.invite,onCardClick:{}).cardify()
//                    LeadCardView(isForSearch: true,status: LeadStatus.quoted,onCardClick:{}).cardify()
//                    LeadCardView(isForSearch: true,status: LeadStatus.scheduled,onCardClick:{}).cardify()
//                    LeadCardView(isForSearch: true,status: LeadStatus.new,onCardClick:{}).cardify()
//                    LeadCardView(isForSearch: true,status: LeadStatus.complete,onCardClick:{}).cardify()
                }
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .padding(.horizontal,25)
        .padding(.top,25)
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
