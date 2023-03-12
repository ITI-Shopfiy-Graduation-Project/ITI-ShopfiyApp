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
            //let username = UserDefaultsManager.sharedInstance.getUserName()
            //let userEmail = UserDefaultsManager.sharedInstance.getUserEmail()
            /let userAddress = UserDefaultsManager.sharedInstance.getUserAddress()/
            let customer = Customer()
            //customer.id = userID
        //customer.addresses?.first?.first_name = coupon
            /*customer.email = userEmail
            customer.first_name = username
            
            let newCustomer = NewCustomer()
            newCustomer.customer = customer
            */
            var newCustomer = NewCustomer()
            newCustomer.customer = customer
            newCustomer.customer?.last_order_name = "ahmed"
        newCustomer.customer?.currency = coupon
        newCustomer.customer?.addresses?.first?.first_name = coupon
        OrderNetwork.sharedinstance.putCustomer(customer: newCustomer) { data, response, error in
                if response != nil {
                    print("response: \(response)")
                }
                else if error != nil {
                    print("error \(error?.localizedDescription)")
                }
            }
            
        }
}
