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
}

