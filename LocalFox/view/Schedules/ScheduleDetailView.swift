//
//  ScheduleDetailView.swift
//  Local Fox
//
//  Created by venkatesh karra on 11/02/24.
//

import SwiftUI

struct ScheduleDetailView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var schedulesVM: SchedulesViewModel
    var selectedSchedule: ScheduleModel
    @State private var showDeletesuccessSneakBar = false
    @State private var showErrorSneakBar = false
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(Strings.ADD_BOOKING).applyFontHeader()
                Spacer()
                Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        VStack {
                            Images.CLOSE
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12,height: 12)
                        } .frame(width: 30,height: 30)
                            .cardify(cardCornerRadius: 15)
                            .background(Color.SCREEN_BG)
                    }
                )
            }.padding(.top, 25)
            ScheduleCardView(schedule: selectedSchedule) {
                
            }
            
            HStack {
                Text("Job linked")
                    .applyFontBold(size: 15)
                    .padding(.top, 30)
                    .padding(.bottom, 5)
                Spacer()
            }
            
            if let job = selectedSchedule.job {
                ScheduleJobCardView(job: job, status: LeadStatus(rawValue: job.status) ?? LeadStatus.new).cardify()
            }
            
            MyButton(text: Strings.DELETE,onClickButton: {
                schedulesVM.deleteSchedule(scheduleID: selectedSchedule._id)
            }, showLoading: schedulesVM.isLoading ,bgColor: Color.PRIMARY).padding(.top,20)
           
            Spacer()
        }.navigationBarHidden(true)
           
            .padding()
            .background(Color.SCREEN_BG.ignoresSafeArea())
            .disabled(schedulesVM.isLoading)
        
            .onChange(of: schedulesVM.isLoading) { isloading in
                if (schedulesVM.deleteSchedulesSuccess == true && schedulesVM.errorString == nil) {
                    self.showDeletesuccessSneakBar = true
                } else if(schedulesVM.isLoading != true && schedulesVM.errorString != nil) {
                    self.showErrorSneakBar = true
                }
            }
            .snackbar(
                show: $showDeletesuccessSneakBar,
                snackbarType: SnackBarType.success,
                title: "Success",
                message: "Schedule Deleted SuccessFully",
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: {self.presentationMode.wrappedValue.dismiss()
                    NotificationCenter.default.post(name: NSNotification.RELOAD_SCHEDULES,
                                                    object: nil, userInfo: nil)},
                isAlignToBottom: true
            )
            .snackbar(
                show: $showErrorSneakBar,
                snackbarType: SnackBarType.error,
                title: "Error",
                message: schedulesVM.errorString,
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: { },
                isAlignToBottom: true
            )
    }
    
}

//#Preview {
//    ScheduleDetailView()
//}
