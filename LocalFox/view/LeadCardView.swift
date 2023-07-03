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

enum LeadStatus: Equatable {
    case active
    case expired
    case invite
    case quoted
    case scheduled
    case complete
    case new
    
    var text: String {
        switch self {
        case .invite: return Strings.INVITE
        case .active: return Strings.ACTIVE
        case .expired: return Strings.EXPIRED
        case .quoted: return Strings.QUOTED
        case .scheduled: return Strings.SSCHEDULED
        case .complete: return Strings.COMPLETED
        case .new: return Strings.EXPIRED
        }
    }
    
    var textColor: Color {
        switch self {
        case .invite: return Color.BLUE
        case .active: return Color.BLUE
        case .expired: return Color.BORDER_RED
        case .quoted: return Color.DARK_PURPLE
        case .scheduled: return Color.BLUE
        case .complete: return Color.TEXT_GREEN
        case .new: return Color.BORDER_RED
        }
    }
    
    var bgColor: Color {
        switch self {
        case .invite: return Color.LIGHT_BLUE
        case .active: return Color.LIGHT_BLUE
        case .expired: return Color.LIGHT_RED
        case .quoted: return Color.LIGHT_PURPLE
        case .scheduled: return Color.LIGHT_BLUE
        case .complete: return Color.LIGHT_GREEN
        case .new: return Color.LIGHT_RED
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
                    VStack {
                        HStack(alignment: .top, spacing: 10) {
                            VStack {
                                if let pic = job.customer?.profilePhoto {
                                    Color.clear.overlay(
                                            AsyncImage(url: URL(string: pic)) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()    // << for image !!
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
                                        .aspectRatio(1, contentMode: .fit) // << for square !!
                                        .clipped()
                                } else {
                                    if let name = job.customer?.fullName {
                                        Text(String(name.prefix(2))).applyFontBold(size: 17).textCase(.uppercase)
                                    } else {
                                        Text("Loading...").applyFontRegular(size: 10)
                                    }
                                }
                               
                            }.frame(width: 43, height: 43 )
                                .cardify()
                                                    
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top){
                                    Text(job.customer?.fullName ?? "")
                                        .applyFontBold(size: 16)
                                    Images.GREEN_CHECK
                                        .padding(.leading, 5)
                                }
                               
                                HStack(alignment: .top){
                                    VStack{
                                        Images.LOCATION_PIN
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15,height: 15)
                                    }
                                    VStack (alignment: .leading, spacing: 5){
                                        Text(job.getFormattedLocation())
                                                .applyFontRegular(color: Color.TEXT_LEVEL_2,size: 13)
                                        
                                        if let date  = job.createdDate.convertDateFormate(sorceFormate: DateFormates.API_DATE_TIME, destinationFormate: DateFormates.LOCAL_DATE_TIME) {
                                            Text("Posted on \(date)")
                                                .applyFontRegular(color: Color.TEXT_LEVEL_3,size: 12)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            
                        }.padding(.vertical, 5)
                        if(!isForSearch){
                            HStack (alignment: .center,spacing: 20){
                                Text(status.text).applyFontRegular(color: status.textColor, size: 12)
                                    .padding(2)
                                    .padding(.horizontal,10).cardify(cardBgColor: status.bgColor).hidden()
                                Spacer()
                                Button(
                                    action: {
                                        openAddressInMap(address: job.getFormattedLocation())
                                    },
                                    label: {
                                        Images.LOCATION_BUTTON
                                    }
                                )
                                Button(
                                    action: {
                                        if job.customer?.emailAddress != nil {
                                            MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
                                        }
                                     },
                                    label: {
                                        Images.EMAIL_BUTTON
                                    }
                                )
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
                                    }
                                )
                            }
                        }
                    }
                }
            }.padding(.horizontal,20)
                .padding(.vertical,20)
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
        if(status == LeadStatus.invite) {
            return Color.BLUE
        } else if(status == LeadStatus.active) {
            return Color.BUTTON_GREEN
        } else {
            return Color.PRIMARY
        }
    }
    
    private func getStatusBGColor() -> Color {
        if(status == LeadStatus.invite) {
            return Color.BLUE
        } else if(status == LeadStatus.active) {
            return Color.BUTTON_GREEN
        } else {
            return Color.PRIMARY
        }
    }
    
}
//struct LeadCardView_Previews: PreviewProvider {
//    
//    static var previews: some View {
////        LeadCardView(status: LeadStatus.active, job: Binding<Job>) {
////            
////        }
//    }
//}
