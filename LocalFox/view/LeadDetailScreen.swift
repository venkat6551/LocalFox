//
//  LeadDetailScreen.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/11/22.
//

import SwiftUI

struct LeadDetailScreen: View {
    var job:Job?
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var selectedImage = ""
    @State private var selectedTabIndex = 0
    @StateObject var jobDetailsVM: JobDetailsViewModel =  JobDetailsViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(Strings.JOB_DETAILS).applyFontHeader()
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
                            } .frame(width: 34,height: 34)
                                .cardify(cardCornerRadius: 15)
                                .background(Color.SCREEN_BG)
                        }
                    )
                }.padding(.top, 25)
                
                if (jobDetailsVM.isLoading) {
                    VStack(alignment: .center) {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        Spacer()
                    }
                   
                } else {
                    ScrollView (showsIndicators: false){
                        if let job = job {
                            LeadCardView(job: job, status: LeadStatus(rawValue: job.status) ?? LeadStatus.new) {
                            }.cardify()
                        }
                        SlidingTabView(selection: self.$selectedTabIndex, tabs: [Strings.ACTIVITY, Strings.DETAILS,Strings.QUOTES,Strings.INVOICES],selectionBarColor:.clear ,activeTabColor: .white,selectionBarBackgroundColor:.clear)
                        
                        switch selectedTabIndex {
                        case 0 :
                            ActivityView(activities: jobDetailsVM.jobDetailsModel?.data?.jobActivities)
                        case 1 :
                            DetailsView(job: jobDetailsVM.jobDetailsModel?.data?.job)
                        case 2 :
                            QuoteView(quotes: jobDetailsVM.jobDetailsModel?.data?.quotes)
                        case 3 :
                            InvoiceView(invoices: jobDetailsVM.jobDetailsModel?.data?.invoices)
                        default:
                            DetailsView(job: job)
                        }
                    }
                }
            }.padding(.horizontal,20)
            Spacer()
        }
        .onAppear {
            if (!jobDetailsVM.getJobDetailsSuccess) {
                if let jobID = job?.id {
                    print("JOB ID: \(jobID)")
                    jobDetailsVM.getJobDetails(jobID: jobID)
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
}

struct DetailsView: View {
    var job:Job?
    @State var selectedImage = ""
    @State private var showPhotoView = false
    var body: some View {
        VStack {
            RowView(title: Strings.JOB_LOCATION,image: Images.LOCATION_PIN, description: job?.getFormattedLocation() ?? "-")
            RowView(title: Strings.HOW_SOON,image: Images.TIME_ICON, description: job?.urgency ?? "-")
            RowView(title: Strings.JOB_DESCRIPTION,image: Images.DESCRIPTION_ICON, description: job?.description ?? "-")
            LeadImagesView(images: job?.images) { image in
                selectedImage = image
                self.showPhotoView = true
            }
        }
        .navigationDestination(isPresented: $showPhotoView) {
            Preview(imageName: selectedImage, totalImages: job?.images)
        }
    }
}

struct ActivityView: View {
    var activities:[ActivityModel]?
    var body: some View {
        ZStack {
            HStack{
                Divider().background(Color.ACTIVITY_LINE_BG)
                    .padding(.leading, 30)
                Spacer()
            }
            VStack(spacing: 20){
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        HStack {
                            Images.NOTES_ICON
                                .resizable()
                                .scaledToFit()
                                .frame(width:20,height: 20)
                            Text(Strings.NOTES)
                                .applyFontRegular(color: Color.NEW_STATUS_NEW, size: 14)
                        }
                        .padding(.vertical,10).padding(.horizontal,25).background(Color.PRIMARY_BG)
                    }).cardify()
                    Button(action: {}, label: {
                        HStack {
                            Images.SCHEDULE_ICON
                                .resizable()
                                .scaledToFit()
                                .frame(width:20,height: 20)
                            Text(Strings.SCHEDULE)
                                .applyFontRegular(color: Color.TEXT_GREEN, size: 14)
                        }
                        .padding(.vertical,10).padding(.horizontal,25).background(Color.LIGHT_GREEN)
                    }).cardify()
                    
                }.padding(.vertical, 10)
                if let activities = activities {
                    ForEach(0 ..< activities.count, id: \.self) {index in
                        let activity = activities[index]
                        ActivityRowView(activity: activity, activityType: ActivityType(rawValue: activity.activityType) ?? .none)
                    }
                }
            }
        }
    }
}

struct QuoteView: View {
    var quotes:[QuoteModel]?
    
    var body: some View {
        VStack {
            if(quotes != nil && !(quotes?.isEmpty ?? true)) {
                if let quotes = quotes {
                    ForEach(0 ..< quotes.count, id: \.self) {index in
                        let quote = quotes[index]
                        NavigationLink {
                            QuoteDetailsView(quote: quote)
                        } label: {
                            QuoteCardView(quote: quote, status: QuoteStatus(rawValue: quote.quoteStatus) ?? .Draft)
                        }
                    }
                }
            } else {
                NoQuotesView()
            }
        }
    }
}

struct InvoiceView: View {
    var invoices:[InvoiceModel]?
    var body: some View {
        VStack {
            if(invoices != nil && !(invoices?.isEmpty ?? true)) {
                if let invoices = invoices {
                    ForEach(0 ..< invoices.count, id: \.self) {index in
                    let invoice = invoices[index]
                        NavigationLink {
                            InvoiceDetailsView(invoice: invoice)
                        } label: {
                            InvoiceCardView(invoice: invoice, status: QuoteStatus(rawValue: invoice.invoiceStatus) ?? .Draft)
                        }
                    }
                }
            }
            else {
                NoInvoicesView()
            }
        }
    }
}

struct RowView: View {
    var title: String
    var image: Image?
    var description: String?
    var body: some View {
        HStack(alignment: .top,spacing: 0) {
            if let image = image {
                image
                    .padding(.horizontal,15)
                    .padding(.vertical,18)
            }
            
            VStack(alignment: .leading,spacing: 5){
                Text(title)
                    .applyFontBold(size: 15)
                if let description = description {
                    Text(description)
                        .applyFontRegular(color:.TEXT_LEVEL_2, size: 14)
                        .lineSpacing(5)
                }
            } .padding(.vertical,18)
            Spacer()
        }.cardify()
            .padding(.top,5)
    }
}

struct NoQuotesView: View {
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(Strings.NO_QUOTES_TITLE).applyFontBold(color:Color.DEFAULT_TEXT,size: 16)
            Text(Strings.NO_QUOTES_MESSAGE).applyFontRegular(color:Color.DEFAULT_TEXT,size: 14).multilineTextAlignment(.center).padding(.horizontal, 70)
            Spacer()
            MyButton(text: Strings.CREATE_NEW_QUOTE) {
                
            }
        }.frame(height: 400)
    }
}

struct NoInvoicesView: View {
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(Strings.NO_INVOICE_TITLE).applyFontBold(color:Color.DEFAULT_TEXT,size: 16)
            Text(Strings.NO_INVOICE_MESSAGE).applyFontRegular(color:Color.DEFAULT_TEXT,size: 14).multilineTextAlignment(.center).padding(.horizontal, 70)
            Spacer()
            MyButton(text: Strings.CREATE_NEW_INVOICE) {
                
            }
        }.frame(height: 400)
    }
}

