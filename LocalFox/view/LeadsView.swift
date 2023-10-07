//
//  LeadsView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI
struct LeadsView: View {
    @ObservedObject var jobsVM: JobsViewModel
    @State private var searchText: String = ""
    @State private var showLeadDetails = false
    @State private var showInvitations = false
    @State private var showBottomSheet: Bool = false
    @State private var selectedJob:Job?
    @State private var filterModel: FilterModel = FilterModel(type: FilterType.new, isAscending: true)
    @State private var updatedFilterModel: FilterModel = FilterModel(type: FilterType.new, isAscending: true)
    
    var onSearchActionClick: () -> Void
    var onfilterActionClick: () -> Void
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Jobs").applyFontHeader()
                    Spacer()
                    Button(
                        action: {
                            onSearchActionClick()
                        },
                        label: {
                            Images.SEARCH
                        }
                    )
                    Button(
                        action: {
                            onfilterActionClick()
                        },
                        label: {
                            Images.FILTER
                        }
                    )
                }
                
                if (jobsVM.jobsModel?.invitationsCount ?? 0 > 0) {
                    InvitationsWaitingView(jobsVM: jobsVM, onCardClick: {
                        showInvitations = true
                    }).padding(.bottom, 5)
                }
                
                ScrollView(showsIndicators: false) {
                    if(jobsVM.jobsModel?.data?.jobs == nil) {
                        ProgressView {
                            Text("Loading...")
                        }
                    }else if(!getFilteredList().isEmpty) {
                        ForEach(getFilteredList()) { job in
                            LeadCardView(job: job, status: LeadStatus(rawValue: job.status) ?? LeadStatus.new) {
                                selectedJob = job
                                showLeadDetails = true
                            }.cardify()
                        }
                    }
                    Spacer()
                } .refreshable {
                    jobsVM.getJobs()
                } 
            }.padding(.init(top: 25, leading: 25, bottom: 0, trailing: 25))
            Spacer()
        }
        .onAppear{
            jobsVM.getJobs()
        }
        
        .onChange(of: jobsVM.isLoading) { isLoading in
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showLeadDetails) {
            LeadDetailScreen(job: selectedJob)
        }
        .navigationDestination(isPresented: $showInvitations) {
            InvitationsListView(jobsVM: jobsVM)
        }
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
    
   
    
    struct InvitationsWaitingView: View {
        let jobsVM: JobsViewModel
        var onCardClick: () -> Void
        var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) { Text("\(jobsVM.jobsModel?.invitationsCount ?? 0)")
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
    
    
    private func getFilteredList() -> [Job] {
        var jobsList:[Job]  = []
        if let jobs = jobsVM.jobsModel?.data?.jobs {
            if (jobsVM.filterType != .none) {
                for num in 0 ..< jobs.count {
                    let job  = jobs[num]                   
                    if( job.status.caseInsensitiveCompare(jobsVM.filterType.rawValue) == .orderedSame) {
                        jobsList.append(job)
                    }
                }
           } else {
                jobsList = jobs
            }
        }
        return jobsList
    }
    
}

struct LeadsView_Previews: PreviewProvider {
    static var previews: some View {        
        LeadsView(jobsVM: JobsViewModel()) {
            
        } onfilterActionClick: {
            
        }
    }
}
