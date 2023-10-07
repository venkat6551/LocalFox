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
    @State private var showBottomSheet: Bool = false
    @State private var filterModel: FilterModel = FilterModel(type: FilterType.new, isAscending: true)
    @State private var updatedFilterModel: FilterModel = FilterModel(type: FilterType.new, isAscending: true)

    @Environment(\.scenePhase) var scenePhase
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
                        } onfilterActionClick: {
                            showBottomSheet = true
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
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    jobsViewModel.getJobs()
                }
            }
            .bottomSheet(
                show: $showBottomSheet,
                title: "Select one",
                onClickDone: {
                    filterModel = updatedFilterModel
                }) {
                    FilterView(filterModel: $updatedFilterModel, filterType: jobsViewModel.filterType,onSelectType: { type in
                        jobsViewModel.filterType = type
                        showBottomSheet = false
                    },onClearType: {
                        jobsViewModel.filterType = .none
                        showBottomSheet = false
                    })
                        .onAppear {
                            updatedFilterModel = filterModel
                        }
                }
        }
        .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
    }
}

struct FilterView: View {
    
    @Binding var filterModel: FilterModel
    @State var filterType:FilterType
    
    var onSelectType : (FilterType) -> Void
    var onClearType : () -> Void
    var body: some View {
        VStack(spacing: 10) {
            FilterRow(
                filterType: FilterType.new,
                currentlySelectedType: filterType
            ) {
                filterType = FilterType.new
            }
            FilterRow(
                filterType: FilterType.Assigned,
                currentlySelectedType: filterType
            ) {
                filterType = FilterType.Assigned
            }
            FilterRow(
                filterType: FilterType.quoted,
                currentlySelectedType: filterType
            ) {
                filterType = FilterType.quoted
            }
            FilterRow(
                filterType: FilterType.completed,
                currentlySelectedType: filterType
            ) {
                filterType = FilterType.completed
            }
            FilterRow(
                filterType: FilterType.scheduled,
                currentlySelectedType: filterType
            ) {
                filterType = FilterType.scheduled
            }
            FilterRow(
                filterType: FilterType.Invoiced,
                currentlySelectedType: filterType
            ) {
                filterType = FilterType.Invoiced
            }
            
            HStack {
                MyButton(
                    text: Strings.CLEAR,
                    onClickButton: {
                        filterType = FilterType.none
                        onClearType()
                    },
                    bgColor: Color.DEFAULT_TEXT
                )
                
                MyButton(
                    text: Strings.SUBMIT,
                    onClickButton: {
                        onSelectType(filterType)
                    },
                    bgColor: Color.PRIMARY
                )
            }.padding(.vertical, 10)
        }
    }
    
    private func updateFilterModel(newFilterType: FilterType) {
        if filterModel.type == newFilterType {
            filterModel.isAscending = !filterModel.isAscending
        } else {
            filterModel.type = newFilterType
            filterModel.isAscending = true // default ascending state
        }
    }
    
    struct FilterRow: View {
        
        var filterType: FilterType
        var currentlySelectedType: FilterType
        var onClick: () -> Void
        
        private let LEADING_ICON_SIZE: CGFloat = 20
        private let ROW_INNER_SPACING: CGFloat = 12
        
        var body: some View {
            Button(action: {
                onClick()
            }, label: {
                HStack(spacing: ROW_INNER_SPACING) {
                    filterType.icon
                        .resizable()
                        .scaledToFill()
                        .frame(width: LEADING_ICON_SIZE, height: LEADING_ICON_SIZE)
                    Text(filterType.rawValue)
                        .applyFontText()
                    Spacer()
                    if filterType == currentlySelectedType {
                        Images.RED_CHECK
                            .resizable()
                            .scaledToFit()
                            .frame(width: LEADING_ICON_SIZE, height: LEADING_ICON_SIZE)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 15)
                .cornerRadius(10)
            }).cardify()
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView(profileVM: ProfileViewModel(),jobsViewModel: JobsViewModel())
    }
}
