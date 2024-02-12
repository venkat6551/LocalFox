//
//  ScheduleCardView.swift
//  Local Fox
//
//  Created by venkatesh karra on 07/02/24.
//

import SwiftUI

struct ScheduleCardView: View {
    var schedule: ScheduleModel
    var onCardClick: () -> Void
    var body: some View {
        HStack {
            VStack(spacing: 5) {
                
                if let day = schedule.date.convertDateFormate(sorceFormate: DateFormates.SHORT_DATE_TIME_2, destinationFormate: DateFormates.LOCAL_DAY) {
                    Text (day).applyFontMedium(size: 16)
                }
                if let date = schedule.date.convertDateFormate(sorceFormate: DateFormates.SHORT_DATE_TIME_2, destinationFormate: DateFormates.LOCAL_ONLY_DATE) {
                    Text(date).applyFontBold(color:Color.DEFAULT_TEXT,size: 24)
                }
                if let month = schedule.date.convertDateFormate(sorceFormate: DateFormates.SHORT_DATE_TIME_2, destinationFormate: DateFormates.LOCAL_MONTH) {
                    Text (month).applyFontMedium(size: 16)
                }
            }
            .frame(width: 64, height: 93)
            .cardify(cardBgColor: Color.BG_COLOR_1)
            .padding([.vertical, .leading],10)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Images.SCHEDULED_FILTER
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                    VStack(alignment: .leading, spacing: 5) {
                        HStack (alignment: .top) {
                            Text ("\(getAMPMTime(time: schedule.startTime)) to \(getAMPMTime(time: schedule.endTime))").applyFontRegular(size: 13)
                            Text(gettimeDiffrence(startTime: schedule.startTime, endTime: schedule.endTime)).applyFontMedium(color: Color.NEW_STATUS_INVOICED, size: 11)
                                .padding(.vertical, 3)
                                .padding(.horizontal, 10)
                                .cardify(cardBgColor: Color.LIGHT_RED)
                        }
                        if let date  = schedule.createdDate.convertDateFormate(sorceFormate: DateFormates.API_DATE_TIME, destinationFormate: DateFormates.LOCAL_DATE_TIME) {
                            Text("Created on \(date)")
                                .applyFontRegular(color: Color.TEXT_LEVEL_2,size: 13)
                        }
                        
                    }
                }
                
                if let job = schedule.job {
                    HStack(alignment: .top) {
                        Images.LOCATION_NEW
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        VStack(alignment: .leading, spacing: 5) {
                            HStack (alignment: .top) {
                                Text (job.getFormattedLocation()).applyFontRegular(size: 13)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
            }
            Spacer()
        }.frame(maxWidth: .infinity).cardify()
            .onTapGesture {
                onCardClick()
            }
    }
    
    
  
}

struct ScheduleCardForJobView: View {
    var schedule: Schedule
    var body: some View {
        HStack {
            VStack(spacing: 5) {
                if let day = schedule.date.convertDateFormate(sorceFormate: DateFormates.SHORT_DATE_TIME_2, destinationFormate: DateFormates.LOCAL_DAY) {
                    Text (day).applyFontMedium(size: 16)
                }
                if let date = schedule.date.convertDateFormate(sorceFormate: DateFormates.SHORT_DATE_TIME_2, destinationFormate: DateFormates.LOCAL_ONLY_DATE) {
                    Text(date).applyFontBold(color:Color.DEFAULT_TEXT,size: 24)
                }
                if let month = schedule.date.convertDateFormate(sorceFormate: DateFormates.SHORT_DATE_TIME_2, destinationFormate: DateFormates.LOCAL_MONTH) {
                    Text (month).applyFontMedium(size: 16)
                }
            }
            .frame(width: 64, height: 93)
            .cardify(cardBgColor: Color.BG_COLOR_1)
            .padding([.vertical, .leading],10)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Images.SCHEDULED_FILTER
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                    VStack(alignment: .leading, spacing: 5) {
                        HStack (alignment: .top) {
                            Text ("\(getAMPMTime(time: schedule.startTime)) to \(getAMPMTime(time: schedule.endTime))").applyFontRegular(size: 13)
                            Text(gettimeDiffrence(startTime: schedule.startTime, endTime: schedule.endTime)).applyFontMedium(color: Color.NEW_STATUS_INVOICED, size: 11)
                                .padding(.vertical, 3)
                                .padding(.horizontal, 10)
                                .cardify(cardBgColor: Color.LIGHT_RED)
                        }
                        if let date  = schedule.createdDate.convertDateFormate(sorceFormate: DateFormates.API_DATE_TIME, destinationFormate: DateFormates.LOCAL_DATE_TIME) {
                            Text("Created on \(date)")
                                .applyFontRegular(color: Color.TEXT_LEVEL_2,size: 13)
                        }
                        
                    }
                }
                
                if let job = schedule.job {
                    HStack(alignment: .top) {
                        Images.LOCATION_NEW
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        VStack(alignment: .leading, spacing: 5) {
                            HStack (alignment: .top) {
                                Text (job.location.getFormattedLocation()).applyFontRegular(size: 13)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
            }
            Spacer()
        }.frame(maxWidth: .infinity).cardify()
            
    }
    
    
  
}

public func getAMPMTime(time: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // fixes nil if device time in 24 hour format
    let date = dateFormatter.date(from: time)
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.string(from: date!).lowercased()
}
 
public func gettimeDiffrence(startTime: String, endTime: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // fixes nil if device time in 24 hour format
    let startdate = dateFormatter.date(from: startTime) ?? Date()
    let enddate = dateFormatter.date(from: endTime) ?? Date()
    let difference = Calendar.current.dateComponents([.hour, .minute], from: startdate, to: enddate)
    var formattedString = ""
    
    if (difference.hour! > 0) {
        if (difference.minute! <= 0) {
            formattedString = String(format: "%02ld Hours", difference.hour!)
        } else {
            formattedString = String(format: "%02ld:%02ld Minutes",difference.hour!, difference.minute!)
        }
    } else if (difference.minute! > 0) {
        formattedString = String(format: "%02ld Minutes", difference.minute!)
    } else {
        formattedString = String(format: "0 Minutes",difference.hour!, difference.minute!)
    }
    return formattedString
}

//#Preview {
//    ScheduleCardView()
//}
