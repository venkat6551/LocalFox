//
//  JobScheduleDetailsView.swift
//  Local Fox
//
//  Created by venkatesh karra on 12/02/24.
//

import SwiftUI

struct JobScheduleDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var schedulesForJobVM: SchedulesForJobViewModel =  SchedulesForJobViewModel()
    var selectedSchedule: Schedule
    @State private var showDeletesuccessSneakBar = false
    @State private var showErrorSneakBar = false
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(Strings.BOOKING_DETAILS).applyFontHeader()
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
            ScheduleCardForJobView(schedule: selectedSchedule).padding(.top,20)
            
            MyButton(text: Strings.DELETE,onClickButton: {
                schedulesForJobVM.deleteSchedule(scheduleID: selectedSchedule._id)
            }, showLoading: schedulesForJobVM.isLoading ,bgColor: Color.PRIMARY).padding(.top,30)
           
            Spacer()
        }.navigationBarHidden(true)
           
            .padding()
            .background(Color.SCREEN_BG.ignoresSafeArea())
            .disabled(schedulesForJobVM.isLoading)
        
            .onChange(of: schedulesForJobVM.isLoading) { isloading in
                if (schedulesForJobVM.deleteSchedulesSuccess == true && schedulesForJobVM.errorString == nil) {
                    self.showDeletesuccessSneakBar = true
                } else if(schedulesForJobVM.isLoading != true && schedulesForJobVM.errorString != nil) {
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
                    NotificationCenter.default.post(name: NSNotification.RELOAD_JOB_DETAILS,
                                                    object: nil, userInfo: nil)},
                isAlignToBottom: true
            )
            .snackbar(
                show: $showErrorSneakBar,
                snackbarType: SnackBarType.error,
                title: "Error",
                message: schedulesForJobVM.errorString,
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: { },
                isAlignToBottom: true
            )
    }
    
}


