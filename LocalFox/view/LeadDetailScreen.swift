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
    @State private var showActivitySheet = false
    @State private var showAddQuote = false
    @State private var showAddSchedule = false
    @State private var showAddNotes = false
    @State private var showAddInvoice = false
    @State private var isAddMenuOpened = false
    @State private var showCompleteJobSuccessSneakBar = false
    @State private var showErrorSneakBar = false
    @State private var showNewQuoteErrorSneakBar = false
    @State private var showNewInvoiceErrorSneakBar = false
    
    @StateObject var newQuoteViewModel:QuoteViewModel  =  QuoteViewModel()
    @StateObject var newInvoiceViewModel:InvoiceViewModel  =  InvoiceViewModel()
    let actionTitles = ["Create Invoice",
                             "Create Quote",
                             "Create Schedule",
                             "Create Note" ]
    let actionTitlesWithComplete = ["Create Invoice",
                                    "Create Quote",
                                    "Create Schedule",
                                    "Create Note",
                                    "Mark as Complete"]
    
    var body: some View {
        ZStack (alignment: .bottomTrailing){
            ZStack {
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
                                    } .frame(width: 30,height: 30)
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
                                        showActivitySheet = true
                                    }.cardify()
                                }
                                SlidingTabView(selection: self.$selectedTabIndex, tabs: [Strings.DETAILS,Strings.QUOTES,Strings.INVOICES,Strings.SCHEDULES],selectionBarColor:.clear ,activeTabColor: .white,selectionBarBackgroundColor:.clear)
                                
                                switch selectedTabIndex {
                                    
                                case 0 :
                                    DetailsView(job: jobDetailsVM.jobDetailsModel?.data?.job)
                                case 1 :
                                    QuoteView(quotes: jobDetailsVM.jobDetailsModel?.data?.quotes) {
                                        self.newQuoteViewModel.createJobQuote(jobID: self.job?.id)
                                    }
                                case 2 :
                                    InvoiceView(invoices: jobDetailsVM.jobDetailsModel?.data?.invoices){
                                        self.newInvoiceViewModel.createJobInvoice(jobID: self.job?.id)
                                    }
                                case 3 :
                                    JobSchdulesView(schedules: jobDetailsVM.jobDetailsModel?.data?.schedules, onClickBtn: {
                                        showAddSchedule = true
                                    })
                                default:
                                    DetailsView(job: job)
                                }
                            }
                        }
                    }.padding(.horizontal,20)
                    Spacer()
                }.disabled(newQuoteViewModel.isLoading || newInvoiceViewModel.isLoading)
                if (newQuoteViewModel.isLoading || newInvoiceViewModel.isLoading){
                    ProgressView()
                }
            }
            if(isAddMenuOpened || jobDetailsVM.isCompleteJobLoading) {
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        if (jobDetailsVM.isCompleteJobLoading) {
                            ProgressView()
                            Spacer()
                        }
                    }
                    Spacer()
                }.background(Color.gray.opacity(0.7))
                    .onTapGesture {
                        isAddMenuOpened = false
                    }
            }
            
            let jobStatus = LeadStatus(rawValue: job!.status) ?? LeadStatus.new
            ScreenIconsAndText(isOpen: $isAddMenuOpened, onButtonClick: { index in
                switch index {
                case 0:
                    self.newInvoiceViewModel.createJobInvoice(jobID: self.job?.id)
                case 1:
                    self.newQuoteViewModel.createJobQuote(jobID: self.job?.id)
                case 2:
                    self.showAddSchedule = true
                case 3:
                    self.showAddNotes = true
                case 4:
                    self.jobDetailsVM.markAsComplete()
                default:print("")
                }
                
            }, iconAndTextTitles: (jobStatus == .scheduled) ?  actionTitlesWithComplete : actionTitles).frame(width: 80, height: 50)
        }.disabled(jobDetailsVM.isCompleteJobLoading)
        .onChange(of: newQuoteViewModel.isLoading) { isloading in
            if (isloading == false && newQuoteViewModel.quoteModel != nil) {
                showAddQuote = true
            } else  if (isloading == false && newQuoteViewModel.errorString != nil){
                self.showNewQuoteErrorSneakBar = true
            }
        }
        .onChange(of: newInvoiceViewModel.isLoading) { isloading in
            if (isloading == false && newInvoiceViewModel.invoiceModel != nil) {
                showAddInvoice = true
            } else  if (isloading == false && newInvoiceViewModel.errorString != nil){
                self.showNewInvoiceErrorSneakBar = true
            }
        }
        .onChange(of: jobDetailsVM.jobCompleteSuccess) { isloading in
            if (jobDetailsVM.jobCompleteSuccess == true && jobDetailsVM.errorString == nil ) {
                self.showCompleteJobSuccessSneakBar = true
            } else if(jobDetailsVM.errorString != nil) {
                self.showErrorSneakBar = true
            }
        }
        .onAppear {
            if (!jobDetailsVM.getJobDetailsSuccess) {
                if let jobID = job?.id {
                    print("JOB ID: \(jobID)")
                    jobDetailsVM.getJobDetails(jobID: jobID)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.RELOAD_JOB_DETAILS))
                { obj in
                    if let jobID = job?.id {
                        jobDetailsVM.getJobDetails(jobID: jobID)
                    }
                }
        .sheet(isPresented: $showActivitySheet){
            ActivityView(activities: jobDetailsVM.jobDetailsModel?.data?.jobActivities)
        }
        .navigationDestination(isPresented: $showAddQuote) {
            if newQuoteViewModel.quoteModel != nil {
                CreateQuoteView(quoteViewModel: newQuoteViewModel)
            }
        }
        .navigationDestination(isPresented: $showAddInvoice) {
            if newInvoiceViewModel.invoiceModel != nil {
                CreateInvoiceView(invoiceViewModel: newInvoiceViewModel)
            }
        }
        .snackbar(
            show: $showCompleteJobSuccessSneakBar,
            snackbarType: SnackBarType.success,
            title: "Success",
            message: "Job status has been updated to complete successfully",
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {
                NotificationCenter.default.post(name: NSNotification.RELOAD_JOB_DETAILS,
                                                object: nil, userInfo: nil)},
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
        .snackbar(
            show: $showNewQuoteErrorSneakBar,
            snackbarType: SnackBarType.error,
            title: "Error",
            message: newQuoteViewModel.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: { },
            isAlignToBottom: true
        )
        
        .snackbar(
            show: $showNewInvoiceErrorSneakBar,
            snackbarType: SnackBarType.error,
            title: "Error",
            message: newInvoiceViewModel.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: { },
            isAlignToBottom: true
        )
        
        .navigationDestination(isPresented: $showAddSchedule) {
            CreateScheduleView(jobDetailsVM: jobDetailsVM)
        }

        .sheet(isPresented: $showAddNotes) {
            AddNotesView(jobDetailsVM: jobDetailsVM)
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
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        VStack {
            HStack {
                Text("Activities").applyFontHeader()
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
            ScrollView {
                ZStack {
                    HStack{
                        Divider().background(Color.ACTIVITY_LINE_BG)
                            .padding(.leading, 30)
                        Spacer()
                    }
                    VStack(spacing: 20){
                        if let activities = activities {
                            ForEach(0 ..< activities.count, id: \.self) {index in
                                let activity = activities[index]
                                ActivityRowView(activity: activity, activityType: ActivityType(rawValue: activity.activityType) ?? .none)
                            }
                        }
                    }
                }.padding(.horizontal,5).padding(.trailing,10)
            }
        }.background(Color.SCREEN_BG)
    }
}

struct QuoteView: View {
    
    var quotes:[QuoteModel]?
    let onClickBtn:()->Void
    @StateObject var newQuoteViewModel:QuoteViewModel  =  QuoteViewModel()
    var body: some View {
        VStack {
            if(quotes != nil && !(quotes?.isEmpty ?? true)) {
                if let quotes = quotes {
                    ForEach(0 ..< quotes.count, id: \.self) {index in
                        let quote = quotes[index]
                        NavigationLink {
                            ViewQuoteDetailsView(quote: quote)
                        } label: {
                            QuoteCardView(quote: quote, status: QuoteStatus(rawValue: quote.quoteStatus) ?? .Draft)
                        }
                    }
                }
            } else {
                NoQuotesView {
                    onClickBtn()
                }
            }
        }
    }
}

struct JobSchdulesView: View {
    
    var schedules:[Schedule]?
    @StateObject var schedulesViewModel: SchedulesViewModel = SchedulesViewModel()
    let onClickBtn:()->Void
    var body: some View {
        VStack {
            if(schedules != nil && !(schedules?.isEmpty ?? true)) {
                if let schedules = schedules {
                    ForEach(0 ..< schedules.count, id: \.self) {index in
                        let schedule = schedules[index]
                        NavigationLink {
                            JobScheduleDetailsView(selectedSchedule: schedule)
                        } label: {
                            ScheduleCardForJobView(schedule: schedule)
                        }
                    }
                }
            } else {
                NoSchedulesView {
                    onClickBtn()
                }
            }
        }
    }
}



struct InvoiceView: View {
    var invoices:[InvoiceModel]?
    let onClickBtn:()->Void
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
                NoInvoicesView {
                    onClickBtn()
                }
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
    
    let onClickBtn:()->Void
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(Strings.NO_QUOTES_TITLE).applyFontBold(color:Color.DEFAULT_TEXT,size: 16)
            Text(Strings.NO_QUOTES_MESSAGE).applyFontRegular(color:Color.DEFAULT_TEXT,size: 14).multilineTextAlignment(.center).padding(.horizontal, 70)
            Spacer()
            MyButton(text: Strings.CREATE_NEW_QUOTE) {
                onClickBtn()
            }
        }.frame(height: 400)
    }
}

struct NoSchedulesView: View {
    
    let onClickBtn:()->Void
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(Strings.NO_SCHEDULES_TITLE).applyFontBold(color:Color.DEFAULT_TEXT,size: 16)
            Text(Strings.NO_SCHEDULES_MESSAGE).applyFontRegular(color:Color.DEFAULT_TEXT,size: 14).multilineTextAlignment(.center).padding(.horizontal, 70)
            Spacer()
            MyButton(text: Strings.CREATE_NEW_QUOTE) {
                onClickBtn()
            }
        }.frame(height: 400)
    }
}


struct NoInvoicesView: View {
    let onClickBtn:()->Void
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(Strings.NO_INVOICE_TITLE).applyFontBold(color:Color.DEFAULT_TEXT,size: 16)
            Text(Strings.NO_INVOICE_MESSAGE).applyFontRegular(color:Color.DEFAULT_TEXT,size: 14).multilineTextAlignment(.center).padding(.horizontal, 70)
            Spacer()
            MyButton(text: Strings.CREATE_NEW_INVOICE) {
                onClickBtn()
            }
        }.frame(height: 400)
    }
}

struct ScreenIconsAndText: View {
    @Binding var isOpen:Bool
    var onButtonClick: (Int)->Void
    let iconAndTextImageNames = [
        Images.NOTES_ADD_ICON,
        Images.SCHEDULE_ADD_ICON,
        Images.QUOTE_ADD_ICON,
        Images.INVOICE_ADD_ICON,
        Images.SUCCESS_TICK
    ]
    
    var iconAndTextTitles:[String]
    
    var body: some View {
        let mainButton2 = MainButton(isOpen: $isOpen)
        let textButtons = iconAndTextTitles.enumerated().map { index, value in
            IconAndTextButton(imageName: iconAndTextImageNames[index], buttonText: value)
                .onTapGesture {
                    print(index)
                    onButtonClick(index)
                    isOpen.toggle()
                }
        }
        
        
        let menu2 = FloatingButton(mainButtonView: mainButton2, buttons: textButtons, isOpen: $isOpen)
            .straight()
            .direction(.top)
            .alignment(.right)
            .spacing(10)
            .initialOpacity(0)
        
        return VStack {
            HStack {
                Spacer()
                menu2
            }
        }
        
    }
}
struct MainButton: View {
    @Binding var isOpen:Bool
    var width: CGFloat = 60
    
    var body: some View {
        ZStack {
            Color.PRIMARY
                .frame(width: width, height: width)
                .cornerRadius(width / 2)
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 15)
            if(isOpen) {
                Images.RED_CLOSE_ROUND
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            } else {
                Images.PLUS_ICON
                    .foregroundColor(.white)
            }
        }
    }
}

struct MainButtonOpened: View {
    
    var width: CGFloat = 60
    
    var body: some View {
        ZStack {
            Color.PRIMARY
                .frame(width: width, height: width)
                .cornerRadius(width / 2)
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 15)
            Images.RED_CLOSE_ROUND
                .foregroundColor(.white)
        }
    }
}
struct IconAndTextButton: View {
    
    var imageName: Image
    var buttonText: String
    let imageWidth: CGFloat = 22
    
    var body: some View {
        ZStack {
            Color.white
            HStack {
                imageName
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: imageWidth, height: imageWidth)
                    .clipped()
                Text(buttonText).applyFontRegular(color: .DEFAULT_TEXT,size: 16)
                Spacer()
            }
            .padding(.horizontal, 15)
        }
        .frame(width: 200, height: 45)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.DEFAULT_TEXT, lineWidth: 1)
        )
    }
}

