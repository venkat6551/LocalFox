//
//  JobDetailsViewModel.swift
//  Local Fox
//
//  Created by venkatesh karra on 16/11/23.
//

import Foundation

class JobDetailsViewModel: ObservableObject {
    @Published var jobDetailsModel: JobDetailsModel?
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var getJobDetailsSuccess: Bool = false
    @Published var addJobNotesSuccess: Bool = false
    @Published var addScheduleSuccess: Bool = false
    @Published var createJobquoteSuccess: Bool = false
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    func getJobDetails(jobID: String) {
        getJobDetailsSuccess = false
        errorString = nil
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.getJobDetails(_jobID: jobID) { [weak self] success, jobDetails, errorString in
                DispatchQueue.main.async {
                    self?.getJobDetailsSuccess = success
                    self?.errorString = errorString
                    self?.jobDetailsModel = jobDetails
                    self?.isLoading = false
                }
            }
        }
    }
    
    func createJobQuote(jobID: String) {
        createJobquoteSuccess = false
        errorString = nil
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let jobID  = self.jobDetailsModel?.data?.job.id {
                self.apiService.createJobQuote(_jobID: jobID) { [weak self] success, jobDetailsModel, errorString in
                    DispatchQueue.main.async {
                        self?.createJobquoteSuccess = success
                        self?.errorString = errorString
                        self?.isLoading = false
                    }
                }
            }
        }
    }
    
    func addJobNotes(notes: String) {
        guard let data = self.jobDetailsModel?.data else {
            return
        }
        addJobNotesSuccess = false
        errorString = nil
        isLoading = true
        apiService.addJobNotes(jobID: data.job.id, notes: notes) {[weak self] success, errorString in
            DispatchQueue.main.async {
                self?.addJobNotesSuccess = success
                self?.errorString = errorString
                self?.isLoading = false
            }
        }
    }
    
    func addJobSchedule(date: String,starttime: String, endTime:String) {
        guard let data = self.jobDetailsModel?.data else {
            return
        }
        addScheduleSuccess = false
        errorString = nil
        isLoading = true
        
        apiService.addSchedule(jobID: data.job.id, date: date, starttime: starttime, endTime: endTime) { [weak self] success, errorString in
            DispatchQueue.main.async {
                self?.addScheduleSuccess = success
                self?.errorString = errorString
                self?.isLoading = false
            }
        }
       
    }
}

