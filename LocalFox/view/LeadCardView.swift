//
//  LeadCardView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI
import MessageUI
import CoreLocation
import MapKit

enum LeadStatus:String, Equatable  {
    
    case quoted = "QUOTED"
    case scheduled = "SCHEDULED"
    case complete = "COMPLETE"
    case new = "NEW"
    case Invoiced = "INVOICED"
    case Assigned = "ASSIGNED"
    
    var text: String {
        switch self {
        case .quoted: return "Quoted"
        case .scheduled: return "Scheduled"
        case .complete: return "Complete"
        case .new: return "New"
        case .Invoiced: return "Invoiced"
        case .Assigned: return "Assigned"
        }
    }
    
    var textColor: Color {
        switch self {
        case .quoted: return Color.DARK_PURPLE
        case .scheduled: return Color.BLUE
        case .complete: return Color.TEXT_GREEN
        case .new: return Color.NEW_STATUS_NEW
        case .Invoiced: return Color.NEW_STATUS_INVOICED
        case .Assigned: return Color.NEW_STATUS_ASSIGNED
        }
    }
    
    var bgColor: Color {
        switch self {
        case .quoted: return Color.LIGHT_PURPLE
        case .scheduled: return Color.LIGHT_BLUE
        case .complete: return Color.LIGHT_GREEN
        case .new: return Color.NEW_STATUS_NEW_BG
        case .Invoiced: return Color.LIGHT_RED
        case .Assigned: return Color.NEW_STATUS_ASSIGNED_BG
        }
    }
}



struct LeadCardView: View {
    @State var job: Job
    @State var isForSearch = false
    @State var status:LeadStatus
    var onCardClick: () -> Void
    
    @State var isShowingMailView = false
    @State var alertNoMail = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    let colors = ["#f43f5e","#ec4899", "#d946ef", "#a855f7", "#8b5cf6","#22c55e","#84cc16", "#ef4444", "#f97316", "#6366f1", "#3b82f6", "#0ea5e9", "#06b6d4", "#14b8a6", "#10b981", "#f59e0b", "#eab308", "#64748b"]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack (alignment: .top){
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 3) {
                            Text("•").applyFontRegular(color: status.textColor, size: 20).padding(.leading, 5).padding(.bottom, 2)
                            Text(status.text).applyFontRegular(color: status.textColor, size: 12)
                                .padding(.vertical, 2)
                                .padding(.trailing, 10)
                        }.cardify(cardBgColor: status.bgColor)
                        
                        VStack(alignment: .leading,spacing: 5) {
                            Text(job.jobTitle).applyFontBold(color: Color.DEFAULT_TEXT, size: 16)
                            HStack (spacing: 3){
                                Images.LOCATION_NEW
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15,height: 15)
                                Text(job.getShortFormattedLocation())
                                    .applyFontRegular(color: Color.TEXT_LEVEL_2,size: 12)
                            }
                        }
                        HStack(alignment: .center, spacing: 10) {
                            VStack {
                                if let pic = job.getUser()?.profilePhoto {
                                    Color.clear.overlay(
                                        AsyncImage(url: URL(string: pic)) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            default:
                                                if let name = job.getUser()?.fullName {
                                                    Text(String(name.prefix(2))).applyFontBold(size: 17).textCase(.uppercase)
                                                } else {
                                                    Text("Loading...").applyFontRegular(size: 10)
                                                }
                                            }
                                        }
                                    )
                                    .frame(width: 100, height: 80, alignment: .center)
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipped()
                                } else {
                                    if let name = job.getUser()?.fullName {
                                        Text(String(name.prefix(2))).applyFontBold(size: 17).textCase(.uppercase)
                                    } else {
                                        Text("Loading...").applyFontRegular(size: 10)
                                    }
                                }
                                
                            }.frame(width: 43, height: 43 )
                                .background(Color(hex: colors.randomElement()!))
                                .cardify()
                                .padding(.leading, 10)
                                .padding(.vertical, 10)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(job.getUser()?.fullName ?? "").applyFontMedium(size: 15)
                                
                                HStack(alignment: .top){
                                    if let date  = job.createdDate.convertDateFormate(sorceFormate: DateFormates.API_DATE_TIME, destinationFormate: DateFormates.LOCAL_DATE_TIME) {
                                        Text("Posted on \(date)")
                                            .applyFontRegular(color: Color.TEXT_LEVEL_3,size: 11)
                                    }
                                    Spacer()
                                }
                            }.padding(.vertical, 10)
                            Button(
                                action: {
                                    if let mobileNum = job.getUser()?.mobileNumber {
                                        let telephone = "tel://"
                                        let formattedString = telephone + mobileNum
                                        guard let url = URL(string: formattedString) else { return }
                                        UIApplication.shared.open(url)
                                    }
                                },
                                label: {
                                    Images.CALL_BUTTON
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 43, height: 43 )
                                }
                            ).padding(.trailing, 10)
                        }.background(Color.LIGHT_GRAY_BG).cardify()
                            .padding(.vertical, 5)
                    }
                }
            }.padding(15)
        }.contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .onTapGesture {
                onCardClick()
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: self.$result,recipients: [job.getUser()?.emailAddress ?? ""])
            }
            .alert(isPresented: self.$alertNoMail) {
                Alert(title: Text("NO MAIL SETUP"))
            }
    }
    
    
    ///Opens text address in maps
    func openAddressInMap(address: String?){
        guard let address = address else {return}
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks?.first else {
                return
            }
            
            let location = placemarks.location?.coordinate
            
            if let lat = location?.latitude, let lon = location?.longitude{
                let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)))
                destination.name = address
                
                MKMapItem.openMaps(
                    with: [destination]
                )
            }
        }
    }
    
    private func getLocation() -> String {
        
        var location = ""
        
        if let streenNum = job.location?.streetNumber {
            location = streenNum
        }
        if let streenName = job.location?.streetName {
            location = "\(location) \(streenName)"
        }
        
        if location.count > 0 {
            location = "\(location) \n"
        }
        
        if let suburb = job.location?.suburb {
            location = "\(location)\(suburb)"
        }
        if let state = job.location?.state {
            location = "\(location) \(state)"
        }
        
        if let postCode = job.location?.postCode {
            location = "\(location) \(postCode)"
        }
        
        return location
    }
    private func getStatusColor() -> Color {
        //        if(status == LeadStatus.invite) {
        //            return Color.BLUE
        //        } else if(status == LeadStatus.active) {
        //            return Color.BUTTON_GREEN
        //        } else {
        return Color.PRIMARY
        //  }
    }
    
    private func getStatusBGColor() -> Color {
        //        if(status == LeadStatus.invite) {
        //            return Color.BLUE
        //        } else if(status == LeadStatus.active) {
        //            return Color.BUTTON_GREEN
        //        } else {
        return Color.PRIMARY
        //        }
    }
    
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
