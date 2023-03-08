//
//  ShoppingCartViewModel.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import Foundation
class ShoppingCartViewModel {
    var cartsUrl : String?

    var bindingCart : (()->()) = {}
    var cartList :DrafOrder?{
        didSet{
            bindingCart()
        }
    }
    
    func getShoppingCart(userId: Int) {
        CartNetwork.sharedInstance.fetchUserCart(userEmail: "dsax") { result in
            if let result = result {
//                self.cartList = result.draft_order?.line_items
            }
        }
       /* AddressNetwork.sharedInstance.fetchAllUserAddresses(userId: userId) { result in
            if let result = result {
                self.addressList = result.addresses
            }
        }*/
    }
}
extension ShoppingCartViewModel:CartProtocol {
    func postNewCart(userCart: [String:Any], completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
        CartNetwork.sharedInstance.postCart(userCart:userCart) { data, response, error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, response as? HTTPURLResponse, error)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
            _ = json["customer"] as? Dictionary<String,Any>
            //self.saveCustomerDataToUserDefaults(customer: customer)
            completion(data, response as? HTTPURLResponse, nil)
        }
    }
}
extension ShoppingCartViewModel {
    
    func getProductsFromCategory() {
        CartNetwork.CartfetchData(url: cartsUrl, handlerComplition:{ result in
            self.cartList = result?.draft_order
        } )}
    
    
    
    
    
}
    
    
    
    
    
    

