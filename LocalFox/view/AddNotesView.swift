//
//  AddNotesView.swift
//  Local Fox
//
//  Created by venkatesh karra on 05/01/24.
//

import SwiftUI

struct AddNotesView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var jobDetailsVM: JobDetailsViewModel
    @State private var showsuccessSneakBar = false
    @State private var showErrorSneakBar = false
    @State var notes = ""
    var body: some View {
        VStack {
            HStack {
                Text(Strings.ADD_JOB_NOTES).applyFontHeader()
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    VStack {
                        Images.CLOSE
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12,height: 12)
                    } .frame(width: 30,height: 30)
                        .cardify(cardCornerRadius: 15)
                }
            }.padding(.top, 35).padding(.bottom, 25)
                .padding(.horizontal, 25)
            VStack (alignment: .leading){
                Text("Notes").applyFontRegular(color: Color.TEXT_LEVEL_3, size: 16)
                TextEditor(text: $notes)
                                .foregroundStyle(.secondary)
                                .cardify()
                                .frame(height: 162)
                
                MyButton(text: Strings.SUBMIT, onClickButton: {
                    jobDetailsVM.addJobNotes(notes: notes)
                }, showLoading: jobDetailsVM.isLoading, bgColor: Color.PRIMARY).padding(.top, 25)
               
                Spacer()
            } .padding(.horizontal,25)
        }.background(Color.SCREEN_BG)
            .disabled(jobDetailsVM.isLoading)
            .onChange(of: jobDetailsVM.isLoading) { isloading in
                if (jobDetailsVM.addJobNotesSuccess == true && jobDetailsVM.errorString == nil) {
                    self.showsuccessSneakBar = true
                } else if(jobDetailsVM.errorString != nil) {
                    self.showErrorSneakBar = true
                }
            }
            .snackbar(
                show: $showsuccessSneakBar,
                snackbarType: SnackBarType.success,
                title: "Success",
                message: "Noted Added SuccessFully",
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: {
                    self.presentationMode.wrappedValue.dismiss()
                    NotificationCenter.default.post(name: NSNotification.RELOAD_JOB_DETAILS,
                                                    object: nil, userInfo: nil)
                },
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
}

//#Preview {
//    AddNotesView()
//}
