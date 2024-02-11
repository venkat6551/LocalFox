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
    @State private var selectedDate = Date()
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
                    Text(selectedDateTypeIndex == 2 ? getselectedDateStr() : "Select date").applyFontMedium(color: selectedDateTypeIndex == 2 ? Color.white :Color.DEFAULT_TEXT, size: 13).padding(.horizontal, 10)
                }.frame(height: 32)
                    .background(selectedDateTypeIndex == 2 ? Color.PRIMARY :Color.BG_COLOR_2).cardify()
                    .overlay{DatePicker(
                                     "",
                                     selection: $selectedDate,
                                     displayedComponents: [.date]
                                 )
                                  .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                                  .onChange(of: selectedDate, perform: { value in
                                      selectedDateTypeIndex = 2
                                   })
                              }
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
                else  if(!getFilteredList().isEmpty){
                    ForEach(getFilteredList()) { schedule in
                        ScheduleCardView(schedule: schedule) {
                            selectedSchedule = schedule
                            showScheduleDetails = true
                        }
                    }
                } else {
                    Text("No Schedules")
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

    private func getFilteredList() -> [ScheduleModel] {
        var schedulesList:[ScheduleModel]  = []
        if let schedules = schedulesVM.schedulesModel?.data {
            var filterDateStr =  getDateFromFilter()
            schedulesList = schedules.filter { model in
                model.date == filterDateStr
            }
        }
        return schedulesList;
    }
    func getDateFromFilter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormates.SHORT_DATE_TIME_2
        if selectedDateTypeIndex == 0 {
            return dateFormatter.string(from: Date.today)
        } else if (selectedDateTypeIndex == 1){
            return dateFormatter.string(from: Date.tomorrow)
        } else {
            return dateFormatter.string(from:selectedDate)
        }
    }
    func getselectedDateStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormates.SHORT_DATE_TIME_2
        return dateFormatter.string(from:selectedDate)
    }
}

//#Preview {
//    SchedulesView()
//}
