//
//  ShoppingCartViewModel.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import Foundation
class ShoppingCartViewModel {
    var cartsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/draft_orders.json"

    var bindingCart : (()->()) = {}
    var bindingCartt : (()->()) = {}
    var cartList :[LineItem]?{
        didSet{
            bindingCart()
        }
    }
    var cartResult :ShoppingCart?{
        didSet{
            bindingCartt()
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
    
    func getCart() {
        CartNetwork.CartfetchData(url: cartsUrl, handlerComplition:{ result in
            self.cartResult = result
//            print ("draft email\(result?.draft_order![1].email)")
        } )}

    
    
    
    
}
extension ShoppingCartViewModel {
    func putNewCart(userCart: ShoppingCartPut, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
        CartNetwork.sharedInstance.putCart(userCart:userCart) { data, response, error in
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
    
    
    
    
    
    

