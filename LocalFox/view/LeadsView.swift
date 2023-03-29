//
//  LeadsView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI
struct LeadsView: View {
    @StateObject var jobsVM: JobsViewModel
    @State private var searchText: String = ""
    @State private var showLeadDetails = false
    @State private var showInvitations = false
    @State private var showBottomSheet: Bool = false
    @State private var filterModel: FilterModel = FilterModel(type: FilterType.active, isAscending: true)
    @State private var updatedFilterModel: FilterModel = FilterModel(type: FilterType.active, isAscending: true)
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Jobs").applyFontHeader()
                    Spacer()
                    Images.SEARCH
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34,height: 34)
                        .padding(.trailing, 5)                
                }
                
                InvitationsWaitingView(onCardClick: {
                    showInvitations = true
                }).padding(.bottom, 5)
                
                ScrollView(showsIndicators: false) {
                    
                    
                    if let jobs = jobsVM.jobsModel?.data?.jobs {
                        ForEach(jobs) { job in
                            LeadCardView(job: job, status: LeadStatus.active) {
                                showLeadDetails = true
                            }.cardify()
                        }
                    }
                    
//                        
//                    LeadCardView(status: LeadStatus.active, onCardClick: {
//                        showLeadDetails = true
//                    }).cardify()
//                    LeadCardView(status: LeadStatus.active, onCardClick: {
//                        showLeadDetails = true
//                    }).cardify()
//                    LeadCardView(status: LeadStatus.expired, onCardClick: {
//                        showLeadDetails = true
//                    }).cardify()
                    Spacer()
                }
            }
            Spacer()
        }
        .onAppear{
            jobsVM.getJobs()
        }
        .onChange(of: jobsVM.isLoading) { isLoading in
        }
        
        .navigationBarHidden(true)
        .bottomSheet(
            show: $showBottomSheet,
            title: "Select one",
            doneButtonText: "Done",
            onClickDone: {
                filterModel = updatedFilterModel
            }) {
                FilterView(filterModel: $updatedFilterModel)
                    .onAppear {
                        updatedFilterModel = filterModel
                    }
            }
        .navigationDestination(isPresented: $showLeadDetails) {
            LeadDetailScreen()
        }
        .navigationDestination(isPresented: $showInvitations) {
            InvitationsListView()
        }
        .padding(.init(top: 25, leading: 25, bottom: 0, trailing: 25))
        .background(Color.SCREEN_BG.ignoresSafeArea())
        
    }
    
    struct FilterView: View {
        
        @Binding var filterModel: FilterModel
        
        var body: some View {
            VStack(spacing: 10) {
                FilterRow(
                    sortType: FilterType.active,
                    currentlySelectedType: filterModel.type,
                    isAscending: filterModel.isAscending
                ) {
                    updateFilterModel(newFilterType: FilterType.active)
                }
                FilterRow(
                    sortType: FilterType.quoted,
                    currentlySelectedType: filterModel.type,
                    isAscending: filterModel.isAscending
                ) {
                    updateFilterModel(newFilterType: FilterType.quoted)
                }
                FilterRow(
                    sortType: FilterType.completed,
                    currentlySelectedType: filterModel.type,
                    isAscending: filterModel.isAscending
                ) {
                    updateFilterModel(newFilterType: FilterType.completed)
                }
                FilterRow(
                    sortType: FilterType.scheduled,
                    currentlySelectedType: filterModel.type,
                    isAscending: filterModel.isAscending
                ) {
                    updateFilterModel(newFilterType: FilterType.scheduled)
                }
                FilterRow(
                    sortType: FilterType.expired,
                    currentlySelectedType: filterModel.type,
                    isAscending: filterModel.isAscending
                ) {
                    updateFilterModel(newFilterType: FilterType.expired)
                }
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
            
            var sortType: FilterType
            var currentlySelectedType: FilterType
            var isAscending: Bool
            var onClick: () -> Void
            
            private let LEADING_ICON_SIZE: CGFloat = 20
            private let ROW_INNER_SPACING: CGFloat = 12
            
            var body: some View {
                Button(action: {
                    onClick()
                }, label: {
                    HStack(spacing: ROW_INNER_SPACING) {
                        sortType.icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: LEADING_ICON_SIZE)
                        Text(sortType.text)
                            .applyFontText()
                        Spacer()
                        if sortType == currentlySelectedType {
                            Images.GREEN_CHECK
                                .resizable()
                                .scaledToFit()
                                .frame(width: LEADING_ICON_SIZE)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
                    .cornerRadius(10)
                }).cardify()
            }
        }
    }
    
    struct InvitationsWaitingView: View {
        var onCardClick: () -> Void
        var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) { Text("3")
                                .applyFontBold(size: 18)
                        }
                        .frame(width: 30, height: 30)
                        .cardify(cardBgColor: Color.NOTIFICATION_BG)
                        Text("Invitations waiting for your action")
                            .applyFontMedium(size: 15)
                        Spacer()
                        Images.DISCLOSURE
                            .padding(.trailing, 10)
                    }
                }.padding(10)
            }.contentShape(Rectangle())
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    onCardClick()
                }
                .cardify(cardBgColor: Color.LIGHT_PINK, borderColor: Color.BORDER_RED)
        }        
    }
}

struct LeadsView_Previews: PreviewProvider {
    static var previews: some View {
        LeadsView(jobsVM: JobsViewModel())
    }
}
