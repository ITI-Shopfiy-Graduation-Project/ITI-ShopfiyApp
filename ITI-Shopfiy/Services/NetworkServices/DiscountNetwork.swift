//
//  DiscountNetwork.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 04/03/2023.
//

import Foundation
import Alamofire
class DiscountNetwork:DiscountProtocol{
    static func discountfetchData(url: String?, handlerComplition: @escaping (DiscountCode?) -> Void) {
        AF.request("\(url!)").responseData {response in
            guard let data = response.data else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(DiscountCode.self, from: data)
                handlerComplition(result)
            }catch let error {
                print(error.localizedDescription)
                handlerComplition(nil)
            }
            
            
        }
        
        
        
    }
    
}
