//
//  GetoOrderNetwork.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 11/03/2023.
//

import Foundation
import Alamofire
class GetOrderNetwork:NgetOrdersProtocol{
    static func orderfetchData(url: String?, handlerComplition: @escaping (Order?) -> Void) {
        AF.request("\(url!)").responseData {response in
            guard let data = response.data else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(Order.self, from: data)
                handlerComplition(result)
            }catch let error {
                print(error.localizedDescription)
                handlerComplition(nil)
            }
            
            
        }
        
        
        
    }
    
}
