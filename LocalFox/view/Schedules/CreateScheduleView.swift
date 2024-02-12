//
//  CreateScheduleView.swift
//  Local Fox
//
//  Created by venkatesh karra on 11/02/24.
//

import SwiftUI

struct CreateScheduleView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var jobDetailsVM: JobDetailsViewModel
    @State var startTime = ""
    @State var endTime = ""
    @State var date  = ""
    @State private var selectedDate = Date()
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var showAddsuccessSneakBar = false
    @State private var showErrorSneakBar = false
    @State private var timeErrorSneakBar = false
    
    
    var body: some View {
        VStack {
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
            
            VStack(alignment: .leading) {
                Text(Strings.DATE).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16).padding(.top, 20)
                
                Button {
                } label: {
                    HStack {
                        MyInputTextBox(text: $date,keyboardType: .decimalPad).disabled(true)
                    }
                    .frame(height: Dimens.INPUT_FIELD_HEIGHT)
                    .cardify()
                    
                }
                
                .overlay{DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                .onChange(of: selectedDate, perform: { value in
                    date = getselectedDateStr()
                })
                }
                
            }
            
            HStack{
                VStack(alignment: .leading) {
                    Text(Strings.START_TIME).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16).padding(.top, 20)
                    
                    MyInputTextBox(text: $startTime,keyboardType: .decimalPad).disabled(true)
                        .overlay{DatePicker(
                            "",
                            selection: $startDate,
                            displayedComponents: [.hourAndMinute]
                        )
                        .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                        .onChange(of: startDate, perform: { value in
                            startTime = getselectedTimeStr(date: startDate)
                        })
                        }
                }
                VStack(alignment: .leading) {
                    Text(Strings.END_TIME).applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16).padding(.top, 20)
                    
                    MyInputTextBox(text: $endTime,keyboardType: .decimalPad).disabled(true)
                        .overlay{DatePicker(
                            "",
                            selection: $endDate,
                            displayedComponents: [.hourAndMinute]
                        )
                        .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                        .onChange(of: endDate, perform: { value in
                            endTime = getselectedTimeStr(date: endDate)
                        })
                        }
                }
            }
            
            MyButton(text: Strings.SUBMIT,onClickButton: {
                if(gettimeDiffrence(startTime: startTime, endTime: endTime) == "0 Minutes"){
                    timeErrorSneakBar = true
                }
                else {
                    jobDetailsVM.addJobSchedule(date: date, starttime: startTime, endTime: endTime)
                }
            } ,showLoading: jobDetailsVM.isLoading, bgColor: Color.PRIMARY).padding(.top, 30)
            
            Spacer()
        } .navigationBarHidden(true) .disabled(jobDetailsVM.isLoading)
            .padding(.horizontal)
            .background(Color.SCREEN_BG.ignoresSafeArea())
            .onChange(of: jobDetailsVM.isLoading) { isloading in
                if (jobDetailsVM.addScheduleSuccess == true && jobDetailsVM.errorString == nil) {
                    self.showAddsuccessSneakBar = true
                } else if(jobDetailsVM.isLoading != true && jobDetailsVM.errorString != nil) {
                    self.showErrorSneakBar = true
                }
            }
            .snackbar(
                show: $showAddsuccessSneakBar,
                snackbarType: SnackBarType.success,
                title: "Success",
                message: "Schedule creaged SuccessFully",
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: {self.presentationMode.wrappedValue.dismiss()
                    NotificationCenter.default.post(name: NSNotification.RELOAD_JOB_DETAILS,
                                                    object: nil, userInfo: nil)},
                isAlignToBottom: true
            )
            .snackbar(
                show: $timeErrorSneakBar,
                snackbarType: SnackBarType.error,
                title: "Error",
                message: "Please select valid time",
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: { },
                isAlignToBottom: true
            )
            .snackbar(
                show: $showErrorSneakBar,
                snackbarType: SnackBarType.error,
                title: "Error",
                message: jobDetailsVM.errorString,
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: { },
                isAlignToBottom: true
            )
        
    }
    
    func getselectedDateStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormates.SHORT_DATE_TIME_2
        return dateFormatter.string(from:selectedDate)
    }
    
    func getselectedTimeStr(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from:date)
    }
}


