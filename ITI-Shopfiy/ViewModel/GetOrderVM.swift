//
//  GetOrderVM.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 11/03/2023.
//

import Foundation
class GetOrderVM{
    var getOrdersUrl : String?
    var bindingOrder : (()->()) = {}
    
    var OrderResult :Order!{
        didSet{
            bindingOrder()
        }
    }
}
extension GetOrderVM:getOrderProtocol
{
    
    func getOrder() {
        GetOrderNetwork.orderfetchData(url:getOrdersUrl, handlerComplition: { result in
            self.OrderResult =  result
            
        })
        
    }
    
}
