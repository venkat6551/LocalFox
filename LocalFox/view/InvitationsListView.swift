//
//  InvitationsListView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/13/23.
//

import SwiftUI

struct InvitationsListView: View {
    @ObservedObject var jobsVM: JobsViewModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
    @State var count :Int = 0
    
    var body: some View {
        ZStack {
            if let jobInvitations = jobsVM.jobsModel?.data?.jobInviations {
                ForEach(jobInvitations) { job in
                    InvitationView(jobInvitation:job) { accepted in
                        if let jobID = job.job?._id {
                            jobsVM.acceptJob(_id: jobID, accepted: accepted)
                        }
                        count = count+1
                    }
                }
            }
        }
        .onChange(of: count) { newValue in
            if(count == jobsVM.jobsModel?.data?.jobInviations?.count) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct InvitationsListView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationsListView(jobsVM: JobsViewModel())
    }
}
