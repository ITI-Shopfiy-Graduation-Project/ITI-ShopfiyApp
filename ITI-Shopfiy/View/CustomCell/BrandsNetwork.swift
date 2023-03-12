//
//  File.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 27/02/2023.
//


import Foundation
import Alamofire
class BrandsNetwork:BrandsProtocol{
   
static func brandsfetchData(url : String?,handlerComplition : @escaping (BrandsResult?)->Void) {
    AF.request("\(url!)").responseData {response in
            guard let data = response.data else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(BrandsResult.self, from: data)
                handlerComplition(result)
            }catch let error {
                print(error.localizedDescription)
                handlerComplition(nil)
            }
            
          }
      }
    
    
}
