//
//  PaymentServices.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 02/03/2023.
//

import Foundation
import PassKit
//MARK:- LOCAL PROPERTIES


class PaymentService{
    static var sharedInstance = PaymentService()
    private var paymentCostAmount: NSDecimalNumber = 0
    
    private init(){}
    
    func setPayment(totalCost : NSDecimalNumber){
        paymentCostAmount = totalCost
    }
    func getPayment() -> PKPaymentRequest{
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.pushpendra.pay"
        request.supportedNetworks = [.quicPay, .masterCard, .visa]
        request.supportedCountries = ["EGY", "US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EGY"
        request.currencyCode = "EGP"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Pay for your order", amount: paymentCostAmount)]
        return request
        
    }
}
