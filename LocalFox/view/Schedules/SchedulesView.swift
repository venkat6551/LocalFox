//
//  SchedulesView.swift
//  Local Fox
//
//  Created by venkatesh karra on 07/02/24.
//

import SwiftUI

struct SchedulesView: View {
    @ObservedObject var schedulesVM: SchedulesViewModel
    @State private var showScheduleDetails = false
    @State var selectedDateTypeIndex = 0
    @State private var selectedSchedule:ScheduleModel?
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Strings.SCHEDULE).applyFontHeader()
                Spacer()
            }
            HStack {
                Button {
                    selectedDateTypeIndex = 0
                } label: {
                    Text("Today").applyFontMedium(color: selectedDateTypeIndex == 0 ? Color.white :Color.DEFAULT_TEXT, size: 13)
                }.frame(width: 62, height: 32)
                    .background(selectedDateTypeIndex == 0 ? Color.PRIMARY :Color.BG_COLOR_2).cardify()
                Button {
                    selectedDateTypeIndex = 1
                } label: {
                    Text("Tomorrow").applyFontMedium(color: selectedDateTypeIndex == 1 ? Color.white :Color.DEFAULT_TEXT, size: 13)
                }.frame(width: 88, height: 32)
                    .background(selectedDateTypeIndex == 1 ? Color.PRIMARY :Color.BG_COLOR_2).cardify()
                Button {
                    selectedDateTypeIndex = 2
                } label: {
                    Text("Select date").applyFontMedium(color: selectedDateTypeIndex == 2 ? Color.white :Color.DEFAULT_TEXT, size: 13).padding(.horizontal, 10)
                }.frame(height: 32)
                    .background(selectedDateTypeIndex == 2 ? Color.PRIMARY :Color.BG_COLOR_2).cardify()
            }
            
            HStack {
                Text(Strings.BOOKINGS).applyFontBold(size: 20)
                Spacer()
            }.padding(.top, 20)
            
            ScrollView(showsIndicators: false) {
                if(schedulesVM.schedulesModel?.data == nil) {
                    ProgressView {
                        Text("Loading...")
                    }
                }
                else {
                    if let schedules = schedulesVM.schedulesModel?.data {
                        ForEach(schedules) { schedule in
                            ScheduleCardView(schedule: schedule) {
                                selectedSchedule = schedule
                                showScheduleDetails = true
                            }
                        }
                    }
                    
                }
                Spacer()
            } .refreshable {
                schedulesVM.getSchedules()
            }
            Spacer()
        }.padding()
            .onAppear{
                schedulesVM.getSchedules()
            }
            .background(Color.SCREEN_BG.ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showScheduleDetails) {
                if let selectedSchedule = selectedSchedule {
                    ScheduleDetailView(schedulesVM: schedulesVM, selectedSchedule: selectedSchedule)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.RELOAD_SCHEDULES))
                    { obj in
                        schedulesVM.getSchedules()
                    }
    }
}

//#Preview {
//    SchedulesView()
//}
