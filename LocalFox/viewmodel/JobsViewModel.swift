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
        apiService.getJobs { [weak self] success, jobsModel, errorString in
            self?.getJobsSuccess = success
            self?.errorString = errorString
            self?.jobsModel = jobsModel
            self?.isLoading = false
        }
    }
}
