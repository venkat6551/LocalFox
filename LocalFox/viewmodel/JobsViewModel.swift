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
    @Published var acceptOrRejectJobSuccess: Bool = false
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func getJobs(onlyFirstPage:Bool = false) {
        getJobsSuccess = false
        errorString = nil
        isLoading = true
        let pageNumber = onlyFirstPage ? 1 : (jobsModel?.pageNumber ?? 0) + 1;
        apiService.getJobs(_pagenumber: pageNumber) { [weak self] success, jobsModel, errorString in
            self?.getJobsSuccess = success
            self?.errorString = errorString
            if (self?.jobsModel != nil) {
                if let jobs = jobsModel?.data?.jobs {
                    self?.jobsModel?.data?.jobs?.append(contentsOf: jobs)
                    if let jobs = self?.jobsModel?.data?.jobs {
                        self?.jobsModel?.data?.jobs = Array(Set(jobs))
                    }
                }
                if let invitations = jobsModel?.data?.jobInviations {
                    self?.jobsModel?.data?.jobInviations?.append(contentsOf: invitations)
                    if let jobInviations = self?.jobsModel?.data?.jobInviations {
                        self?.jobsModel?.data?.jobInviations = Array(Set(jobInviations))
                    }
                }
                if (!onlyFirstPage) {
                    if let pageNumber = jobsModel?.pageNumber {
                        self?.jobsModel?.pageNumber = pageNumber
                    }
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
    
    func acceptJob(_id id:String, accepted:Bool) {
        
        
        DispatchQueue.main.async {
            self.jobsModel?.data?.jobInviations = self.jobsModel?.data?.jobInviations?.filter({ job in
                job.id != id
            })
        }
        
        acceptOrRejectJobSuccess = false
        errorString = nil
        isLoading = true
        apiService.acceptJob(accepted: accepted, id: id) {[weak self] success, errorString, errorCode in
            if (success == true || errorCode == 400) {
                self?.jobsModel?.data?.jobInviations?.removeAll(where: { JobInviation in
                    JobInviation.job?._id == id
                })
                self?.jobsModel?.invitationsCount  = self?.jobsModel?.data?.jobInviations?.count ?? 0
            }
            self?.acceptOrRejectJobSuccess = success
            self?.errorString = errorString
            self?.isLoading = false
        }
    }
}
