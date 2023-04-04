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
                if(!getFilteredList().isEmpty) {
                    ScrollView (showsIndicators: false){
                        if let jobs = jobsVM.jobsModel?.data?.jobs {
                            ForEach(getFilteredList()) { job in
                                LeadCardView(job: job, status: LeadStatus.active) {
    //                                selectedJob = job
    //                                showLeadDetails = true
                                }.cardify()
                            }
                        }
                        Spacer()
                    }
                }

              
            }
            Spacer()
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
                    job.customer?.fullName?.lowercased().contains(searchText.lowercased()) == true ||
                    job.customer?.emailAddress?.lowercased().contains(searchText.lowercased()) == true ||
                    job.customer?.mobileNumber?.lowercased().contains(searchText.lowercased()) == true ||
                    job.address?.lowercased().contains(searchText.lowercased()) == true
                })
            }
        }
        return jobsList
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(jobsVM: JobsViewModel())
    }
}
