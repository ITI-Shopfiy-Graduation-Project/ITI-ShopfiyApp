//
//  DiscountViewModel.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 04/03/2023.
//

import Foundation
class DiscountViewModel{
    var discountUrl : String?
    var bindingDiscount : (()->()) = {}
    
    var discoutsResults :[Discount]?{
        didSet{
            bindingDiscount()
        }
    }
}
extension DiscountViewModel :getDiscountProtocol
{
    func getDiscount() {
        DiscountNetwork.discountfetchData(url:discountUrl, handlerComplition: { result in
            self.discoutsResults =  result?.discount_codes
            
        })
    }
    
 
    
    
    
    
}
