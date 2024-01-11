//
//  QuoteViewModel.swift
//  Local Fox
//
//  Created by venkatesh karra on 07/01/24.
//

import Foundation
import SwiftUI

class QuoteViewModel: ObservableObject {
    @Published var quoteModel: NewQuoteModel?
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var createJobQuoteSuccess: Bool = false
    @Published var saveOrSendQuoteSuccess: Bool = false
    private let apiService: APIServiceProtocol
    @Published private(set) var isSaveQuoteLoading: Bool = false
    @Published private(set) var isSendQuoteLoading: Bool = false
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    func addLineItem(title: String,descriptiom: String,price: String, taxType: String ) {
        let priceFloat = Float(price) ?? 0
        self.quoteModel?.data.items.append(QuoteItemModel(_id: nil, serviceName: title, serviceDescription: descriptiom, price: priceFloat, tax: getTax(price: priceFloat, taxType: taxType), taxType: taxType, totalItemPrice: getTotalPrice(price: priceFloat, taxType: taxType)))
    }
    
    
    
    func saveQuote() {
        guard let data = quoteModel?.data else {
            return
        }
        saveOrSendQuoteSuccess = false
        errorString = nil
        isSaveQuoteLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.saveQuote(_quoteID: data._id, params: self.getItemsParams()) {[weak self] success, errorString in
                self?.saveOrSendQuoteSuccess = success
                self?.errorString = errorString
                self?.isSaveQuoteLoading = false
            }
        }
    }
    func sendQuote() {
        guard let data = quoteModel?.data else {
            return
        }
        saveOrSendQuoteSuccess = false
        errorString = nil
        isSendQuoteLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.sendQuote(_quoteID: data._id, params: self.getItemsParams()) {[weak self] success, errorString in
                self?.saveOrSendQuoteSuccess = success
                self?.errorString = errorString
                self?.isSendQuoteLoading = false
            }
        }
    }
    
    func getItemsParams() -> [[String : Any]] {
        var items = [[String: Any]]()
        if let data = quoteModel?.data {
            for index in 0 ..< data.items.count {
                let item = data.items[index]
                let itemData: [String: Any] = ["serviceName":item.serviceName, "serviceDescription":item.serviceDescription,"price":item.price, "taxType":item.taxType]
                items.append(itemData)
            }
        }
        return items;
    }
    
    func getTotalTax() -> Float {
        var totalTax:Float = 0.0
        if let items = quoteModel?.data.items {
            totalTax = items.map({$0.tax }).reduce(0, +)
        }
        return totalTax
    }
   
    func getSubtotal() -> Float {
        var totalSum:Float = 0.0
        if let items = quoteModel?.data.items {
            totalSum = items.map({$0.price}).reduce(0, +)
        }
        return totalSum
    }
    
    func getTotalPrice() -> Float {
        var totalSum:Float = 0.0
        if let items = quoteModel?.data.items {
            totalSum = items.map({$0.totalItemPrice}).reduce(0, +)
        }
        return totalSum
    }
    
    func getTax(price: Float, taxType: String) -> Float {
        if (taxType == "TAX_EXCLUSIVE"){
            return price * 0.10
        } else if(taxType == "TAX_INCLUSIVE"){
            return Float(Double((price/11)).rounded(toPlaces: 2))
        } else if(taxType == "NO_TAX"){
            return 0
        }
        return 0
    }
    
    func getTotalPrice(price: Float, taxType: String) -> Float {
        if (taxType == "TAX_EXCLUSIVE"){
            return price + (price * 0.10)
        } else if(taxType == "TAX_INCLUSIVE"){
            return price
        } else if(taxType == "NO_TAX"){
            return price
        }
        return price
    }
    
    func createJobQuote(jobID: String?) {
        
        guard let jobID = jobID else {
            return
        }
        createJobQuoteSuccess = false
        errorString = nil
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.createJobQuote(_jobID: jobID) { [weak self] success, quoteModel, errorString in
                DispatchQueue.main.async {
                    self?.quoteModel = quoteModel
                    self?.createJobQuoteSuccess = success
                    self?.errorString = errorString
                    self?.isLoading = false
                }
            }
        }
    }
}

