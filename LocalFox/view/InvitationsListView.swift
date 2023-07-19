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
    @State private var showErrorSnackbar: Bool = false
    var body: some View {
        ZStack {
            if let jobInvitations = jobsVM.jobsModel?.data?.jobInviations {
                ForEach(jobInvitations) { job in
                    InvitationView(jobInvitation:job, animate: (jobInvitations.count > 1)) { accepted in
                        if let jobID = job.job?._id {
                            jobsVM.acceptJob(_id: jobID, accepted: accepted)
                        }
                    }
                }
            }
            if(jobsVM.isLoading) {
                ProgressView {
                    Text("Loading...")
                }
            }
        }
        .disabled(jobsVM.isLoading)
        .onChange(of: jobsVM.isLoading) { newValue in
            if (jobsVM.isLoading == false) {
                if(jobsVM.jobsModel?.data?.jobInviations?.count == 0 && jobsVM.errorString != nil && jobsVM.acceptOrRejectJobSuccess == true) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                if(jobsVM.errorString != nil && jobsVM.acceptOrRejectJobSuccess == false) {
                    showErrorSnackbar = true
                }
            }
        }
        .snackbar(
            show: $showErrorSnackbar,
            snackbarType: SnackBarType.error,
            title: "Error",
            message: jobsVM.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {
                if(jobsVM.jobsModel?.data?.jobInviations?.count == 0){
                    self.presentationMode.wrappedValue.dismiss()
                }
                   
                showErrorSnackbar = false },
            isAlignToBottom: true
        )
    }
}

struct InvitationsListView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationsListView(jobsVM: JobsViewModel())
    }
}
