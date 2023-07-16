//
//  LandingView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI

struct LandingView: View {
    @StateObject var profileVM: ProfileViewModel
    @StateObject var jobsViewModel: JobsViewModel = JobsViewModel()
    @EnvironmentObject var authenticationStatus: AuthenticationStatus
    private enum TabItem: Int {
        case leads
        case search
        case profile
        
        var icon: Image {
            switch self {
            case .leads: return Images.LEADS_TAB
            case .search: return Images.SEARCH_TAB
            case .profile: return Images.PROFILE_TAB
            }
        }
        
        var title: String {
            switch self {
            case .leads: return Strings.LEADS
            case .search: return Strings.SEARCH
            case .profile: return Strings.PROFILE
            }
        }
    }
    
    private let tabs: [TabItem] = [
        TabItem.leads,
        TabItem.search,
        TabItem.profile
    ]
    
    @State private var selectedTabItem: TabItem = TabItem.leads
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Group {
                    switch selectedTabItem {
                        case .leads:
                        LeadsView(jobsVM: jobsViewModel) {
                            selectedTabItem = .search
                        }
                        case .search:
                        SearchView(jobsVM: jobsViewModel) {
                            selectedTabItem = .leads
                        }
                        case .profile:
                            ProfileView(profileVM: profileVM)
                        }
                    }
                .frame(maxHeight: .infinity)
                    .padding(.bottom, -1 * Dimens.TAB_BAR_CORNER_RADIUS)
                HStack(spacing: 40) {
                    Spacer()
                    ForEach(tabs, id: \.self) { tabItem in
                        Button(action: {
                                selectedTabItem = tabItem
                        },
                               label: {
                            
                            VStack {
                                tabItem.icon
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(selectedTabItem == tabItem ? Color.PRIMARY : Color.HINT_TEXT_COLLOR)
                                    .frame(width: Dimens.TAB_ITEM_ICON_SIZE, height: Dimens.TAB_ITEM_ICON_SIZE)
                                Text(tabItem.title)
                                    .applyFontRegular(color:selectedTabItem == tabItem ? Color.PRIMARY : Color.HINT_TEXT_COLLOR,size: 11)
                            }
                            
                        })
                        Spacer()
                    }
                }
                .padding(.vertical, Dimens.TAB_BAR_VERTICAL_PADDING)
                .padding(.bottom, hasPhysicalHomeButton ? 0 : Dimens.SCREEN_BOTTOM_PADDING)
                .cardify(
                    cardCornerRadius: Dimens.TAB_BAR_CORNER_RADIUS,
                    corners: [UIRectCorner.topLeft, UIRectCorner.topRight]
                )
            }
            .onAppear{
                profileVM.getProfile()
            }
        }
        .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView(profileVM: ProfileViewModel(),jobsViewModel: JobsViewModel())
    }
}
