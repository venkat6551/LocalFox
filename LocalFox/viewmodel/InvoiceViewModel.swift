//
//  InvoiceViewModel.swift
//  Local Fox
//
//  Created by venkatesh karra on 20/01/24.
//

import Foundation
import SwiftUI

class InvoiceViewModel: ObservableObject {
    @Published var invoiceModel: NewInvoiceModel?
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    private let apiService: APIServiceProtocol
    
    @Published var createJobInvoiceSuccess: Bool = false
    @Published var saveOrSendInvoiceSuccess: Bool = false
    
    @Published private(set) var isSaveInvoiceLoading: Bool = false
    @Published private(set) var isSendInvoiceLoading: Bool = false
    @Published var convertToInvoiceSuccess: Bool = false
    @Published var voidInvoiceSuccess: Bool = false
    @Published private(set) var isVoidInvoiceLoading: Bool = false

    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    func addLineItem(title: String,descriptiom: String,price: String, taxType: String ) {
        let priceFloat = Float(price) ?? 0
        self.invoiceModel?.data.items.append(QuoteItemModel(_id: nil, serviceName: title, serviceDescription: descriptiom, price: priceFloat, tax: getTax(price: priceFloat, taxType: taxType), taxType: taxType, totalItemPrice: getTotalPrice(price: priceFloat, taxType: taxType)))
    }
    
    func deleteLineItem(item: QuoteItemModel) {
        self.invoiceModel?.data.items.removeAll(where: { model in
            model.serviceName == item.serviceName && model.serviceDescription == item.serviceDescription && model.price == item.price && model.taxType == item.taxType
        })
    }
    
    func getItemsParams() -> [[String : Any]] {
        var items = [[String: Any]]()
        if let data = invoiceModel?.data {
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
        if let items = invoiceModel?.data.items {
            totalTax = items.map({$0.tax }).reduce(0, +)
        }
        return totalTax
    }
   
    func getSubtotal() -> Float {
        var totalSum:Float = 0.0
        if let items = invoiceModel?.data.items {
            totalSum = items.map({$0.price}).reduce(0, +)
        }
        return totalSum
    }
    
    func getTotalPrice() -> Float {
        var totalSum:Float = 0.0
        if let items = invoiceModel?.data.items {
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
    
    func saveInvoice() {
        guard let data = invoiceModel?.data else {
            return
        }
        saveOrSendInvoiceSuccess = false
        errorString = nil
        isSaveInvoiceLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.saveInvoice(_invoiceID: data._id, params: self.getItemsParams()) {[weak self] success, errorString in
                self?.saveOrSendInvoiceSuccess = success
                self?.errorString = errorString
                self?.isSaveInvoiceLoading = false
            }
        }
    }
    
    func sendInvoice() {
        guard let data = invoiceModel?.data else {
            return
        }
        saveOrSendInvoiceSuccess = false
        errorString = nil
        isSendInvoiceLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.sendInvoice(_invoiceID: data._id, params: self.getItemsParams()) {[weak self] success, errorString in
                self?.saveOrSendInvoiceSuccess = success
                self?.errorString = errorString
                self?.isSendInvoiceLoading = false
            }
        }
    }
    
    
    func createJobInvoice(jobID: String?) {
        guard let jobID = jobID else {
            return
        }
        createJobInvoiceSuccess = false
        errorString = nil
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.createJobInvoice(_jobID: jobID) { [weak self] success, invoiceModel, errorString in
                DispatchQueue.main.async {
                    self?.invoiceModel = invoiceModel
                    self?.createJobInvoiceSuccess = success
                    self?.errorString = errorString
                    self?.isLoading = false
                }
            }
        }
    }
    
    func convertToInvoice(quoteID: String) {
        convertToInvoiceSuccess = false
        errorString = nil
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.apiService.convertToInvoiceFromQuote(_quoteID: quoteID) { [weak self] success, invoiceModel, errorString in
                DispatchQueue.main.async {
                    self?.invoiceModel = invoiceModel
                    self?.convertToInvoiceSuccess = success
                    self?.errorString = errorString
                    self?.isLoading = false
                }
            }
        }
    }
    
    func voidInvoice() {
        guard let invoiceModel = self.invoiceModel else {
            return
        }
        convertToInvoiceSuccess = false
        errorString = nil
        isVoidInvoiceLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.cancelInvoice(invoiceID: invoiceModel.data._id) { [weak self] success, errorString in
                DispatchQueue.main.async {
                    self?.voidInvoiceSuccess = success
                    self?.errorString = errorString
                    self?.isVoidInvoiceLoading = false
                }
            }
        }
    }
}

