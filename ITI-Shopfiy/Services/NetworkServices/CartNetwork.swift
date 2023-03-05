//
//  CartNetwork.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import Foundation
import Alamofire

class CartNetwork {
    static var sharedInstance = CartNetwork()
    private init(){}
    
    func fetchUserCart (userEmail: String ,handlerComplition : @escaping (ShoppingCart?)->Void) {
    AF.request("https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/draft_orders.json?email=maamoun@gmail.com").responseData {response in
            guard let data = response.data else {
                return
            }
            do{
                let result = try JSONDecoder().decode(ShoppingCart.self, from: data)
                handlerComplition(result)
            }catch let error {
                print(error.localizedDescription)
                handlerComplition(nil)
            }
            
          }
      }
}
