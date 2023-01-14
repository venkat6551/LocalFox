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
                    text: $searchText
                ).padding(.bottom, 15)
                ScrollView {
                    LeadCardView(status: LeadStatus.expired,onCardClick:{}).cardify()
                    LeadCardView(status: LeadStatus.expired,onCardClick:{}).cardify()
                    LeadCardView(status: LeadStatus.expired,onCardClick:{}).cardify()
                    LeadCardView(status: LeadStatus.expired,onCardClick:{}).cardify()
                    LeadCardView(status: LeadStatus.expired,onCardClick:{}).cardify()
                    LeadCardView(status: LeadStatus.expired,onCardClick:{}).cardify()
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
