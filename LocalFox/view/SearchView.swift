//
//  SearchView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var jobsVM: JobsViewModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var searchText: String = ""
    @FocusState private var keyboardFocused: Bool
    @State private var selectedJob:Job?
    @State private var showLeadDetails = false
    var onSearchCancleClick: () -> Void
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Search Leads").applyFontHeader()
                    Spacer()
                    
                    Button(
                        action: {
                            UIApplication.shared.endEditing()
                            onSearchCancleClick()
                        },
                        label: {
                            VStack {
                                Images.CLOSE
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12,height: 12)
                            } .frame(width: 34,height: 34)
                                .cardify(cardCornerRadius: 15)
                                .background(Color.SCREEN_BG)
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
                if(!getFilteredList().isEmpty) {
                    ScrollView (showsIndicators: false){
                        ForEach(getFilteredList()) { job in
                            LeadCardView(job: job, isForSearch: true, status: LeadStatus(rawValue: job.status) ?? LeadStatus.new) {
                                                                selectedJob = job
                                                                showLeadDetails = true
                            }.cardify()
                        }
                        Spacer()
                    }
                }
            }
            Spacer()
        }
        .onAppear{
            jobsVM.getJobs()
        }
        .navigationDestination(isPresented: $showLeadDetails) {
            LeadDetailScreen(job: selectedJob)
        }
        .navigationBarHidden(true)
        .padding(.horizontal,25)
        .padding(.top,25)
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
    
    private func getFilteredList() -> [Job] {
        var jobsList:[Job]  = []
        if let jobs = jobsVM.jobsModel?.data?.jobs {
            jobsList = jobs
            if !searchText.isEmpty {
                jobsList = jobsList.filter({ job in
                    let user = job.getUser()
                    return user?.fullName?.lowercased().contains(searchText.lowercased()) == true
                    || user?.emailAddress?.lowercased().contains(searchText.lowercased()) == true
                    ||  user?.mobileNumber?.lowercased().contains(searchText.lowercased()) == true
                    || job.getFormattedLocation().lowercased().contains(searchText.lowercased()) == true
                })
            }
        }
        return jobsList
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(jobsVM: JobsViewModel()) {
        }
    }
}
