//
//  SchedulesViewModel.swift
//  Local Fox
//
//  Created by venkatesh karra on 08/02/24.
//

import Foundation
import SwiftUI

class SchedulesViewModel: ObservableObject {
    @Published var schedulesModel: SchedulesModel?
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var getSchedulesSuccess: Bool = false
    @Published var deleteSchedulesSuccess: Bool = false
    
    
    private let apiService: APIServiceProtocol
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func getSchedules() {
        getSchedulesSuccess = false
        errorString = nil
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.getSchedules {  [weak self] success, schedulesModel, errorString in
                DispatchQueue.main.async {
                    self?.getSchedulesSuccess = success
                    self?.errorString = errorString
                    self?.schedulesModel = schedulesModel
                    self?.isLoading = false
                }
            }
        }
    }
    
    func deleteSchedule(scheduleID: String) {
        deleteSchedulesSuccess = false
        errorString = nil
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {            
            self.apiService.deleteSchedule(scheduleID: scheduleID) {[weak self] success, errorString in
                DispatchQueue.main.async {
                    self?.deleteSchedulesSuccess = success
                    self?.errorString = errorString
                    self?.isLoading = false
                }
            }
        }
    }
}


class SchedulesForJobViewModel: ObservableObject {
    @Published var schedule: Schedule?
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var getSchedulesSuccess: Bool = false
    @Published var deleteSchedulesSuccess: Bool = false
    
    
    private let apiService: APIServiceProtocol
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    
    
    func deleteSchedule(scheduleID: String) {
        deleteSchedulesSuccess = false
        errorString = nil
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.deleteSchedule(scheduleID: scheduleID) {[weak self] success, errorString in
                DispatchQueue.main.async {
                    self?.deleteSchedulesSuccess = success
                    self?.errorString = errorString
                    self?.isLoading = false
                }
            }
        }
    }
}
