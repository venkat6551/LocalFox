//
//  JobsViewModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 25/03/23.
//

import SwiftUI

class JobsViewModel: ObservableObject {
    
    @Published var jobsModel: JobsModel?
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var getJobsSuccess: Bool = false

    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func getJobs() {
        getJobsSuccess = false
        errorString = nil
        isLoading = true
        let pageNumber = (jobsModel?.pageNumber ?? 0) + 1;
        apiService.getJobs(_pagenumber: pageNumber) { [weak self] success, jobsModel, errorString in
            self?.getJobsSuccess = success
            self?.errorString = errorString
            if (self?.jobsModel != nil) {
                if let jobs = jobsModel?.data?.jobs {
                    self?.jobsModel?.data?.jobs?.append(contentsOf: jobs)
                }
//                if let invitations = jobsModel?.data?.jobInviations {
//                    self?.jobsModel?.data?.jobInviations?.append(contentsOf: invitations)
//                }
                if let pageNumber = jobsModel?.pageNumber {
                    self?.jobsModel?.pageNumber = pageNumber
                }
                if let jobsCount = jobsModel?.jobsCount {
                    self?.jobsModel?.jobsCount = jobsCount
                }
                if let invitationsCount = jobsModel?.invitationsCount {
                    self?.jobsModel?.invitationsCount = invitationsCount
                }
            } else {
                self?.jobsModel = jobsModel
            }
            
            self?.isLoading = false
        }
    }
}
