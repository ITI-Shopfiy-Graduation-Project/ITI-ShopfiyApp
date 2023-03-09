//
//  PaymentViewModel.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 02/03/2023.
//

import Foundation
import PassKit
class PaymentViewModel{
    var bindPaymentResult : (() -> ()) = {}
    var paymentRequest : PKPaymentRequest? {
        didSet {
            bindPaymentResult()
        }
    }
    
    
}
