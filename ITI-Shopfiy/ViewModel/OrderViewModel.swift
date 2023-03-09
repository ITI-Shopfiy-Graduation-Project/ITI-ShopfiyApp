//
//  OrderViewModel.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 08/03/2023.
//

import Foundation
class OrderViewModel{
    
}

extension OrderViewModel{
    func postOrder(orderDictionary: [String : Any], completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
        let url = URLService.postOrder()
        OrderNetwork.sharedinstance.post(userOrder: orderDictionary, url: url) { data, response, error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, response as? HTTPURLResponse, error)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
            _ = json["order"] as? Dictionary<String,Any>
            //self.saveCustomerDataToUserDefaults(customer: customer)
            completion(data, response as? HTTPURLResponse, nil)
        }
    }
    
    func updateUserWithCoupon(coupon : String) {
        let userID = UserDefaultsManager.sharedInstance.getUserID()
        let username = UserDefaultsManager.sharedInstance.getUserName()
        let userEmail = UserDefaultsManager.sharedInstance.getUserEmail()
        /*let userAddress = UserDefaultsManager.sharedInstance.getUserAddress()*/
        let customer = Customer()
        customer.id = userID
        customer.email = userEmail
        customer.first_name = username
        customer.currency = coupon
        let newCustomer = NewCustomer()
        newCustomer.customer = customer
        OrderNetwork.sharedinstance.putCustomer(customer: customer) { data, response, error in
            if response != nil {
                print("response: \(response)")
            }
            else if error != nil {
                print("error \(error?.localizedDescription)")
            }
        }
        
    }
}
