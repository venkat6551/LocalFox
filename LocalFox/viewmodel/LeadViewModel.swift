//
//  LeadViewModel.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import Foundation


class LeadViewModel: ObservableObject {
    @Published private(set) var lead: LeadModel?
}
