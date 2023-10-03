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
    
    case quoted = "Quoted"
    case scheduled = "Scheduled"
    case complete = "Complete"
    case new = "New"
    case Invoiced = "Invoiced"
    case Assigned = "Assigned"
    
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
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack (alignment: .top){
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 3) {
                            Text("•").applyFontRegular(color: status.textColor, size: 20).padding(.leading, 5).padding(.bottom, 2)
                            Text(status.rawValue).applyFontRegular(color: status.textColor, size: 12)
                                .padding(.vertical, 2)
                                .padding(.trailing, 10)
                        }.cardify(cardBgColor: status.bgColor)
                        
                        VStack(alignment: .leading,spacing: 5) {
                            Text(job.description).applyFontBold(color: Color.DEFAULT_TEXT, size: 15)
                            HStack (spacing: 3){
                                Images.LOCATION_NEW
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15,height: 15)
                                Text(job.getFormattedLocation())
                                    .applyFontRegular(color: Color.TEXT_LEVEL_2,size: 12)
                            }
                        }
                        HStack(alignment: .center, spacing: 10) {
                            VStack {
                                if let pic = job.customer?.profilePhoto {
                                    Color.clear.overlay(
                                        AsyncImage(url: URL(string: pic)) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            default:
                                                if let name = job.customer?.fullName {
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
                                    if let name = job.customer?.fullName {
                                        Text(String(name.prefix(2))).applyFontBold(size: 17).textCase(.uppercase)
                                    } else {
                                        Text("Loading...").applyFontRegular(size: 10)
                                    }
                                }
                                
                            }.frame(width: 43, height: 43 )
                                .background(status.textColor)
                                .cardify()
                                .padding(.leading, 10)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(job.customer?.fullName ?? "")
                                    .applyFontBold(size: 16)
                                
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
                                    if let mobileNum = job.customer?.mobileNumber {
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
                        }.background(Color.SCREEN_BG).cardify()
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
                MailView(result: self.$result,recipients: [job.customer?.emailAddress ?? ""])
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
