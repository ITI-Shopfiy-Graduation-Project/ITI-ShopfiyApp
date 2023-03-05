//
//  AddressViewModel.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 03/03/2023.
//

import Foundation

class AddressViewModel {
    var bindingAddress : (()->()) = {}
    var addressList :[Address]?{
        didSet{
            bindingAddress()
        }
    }
}
extension AddressViewModel : AddressProtocol{
    func getAllUserAddress(userId: Int) {
        AddressNetwork.sharedInstance.fetchAllUserAddresses(userId: userId) { result in
            if let result = result {
                self.addressList = result.addresses
                print("ViewModel : \(String(describing: self.addressList))")
            }
        }
    }
    
    func postNewAddress(userAddress: PostAddress, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
        AddressNetwork.sharedInstance.postAddress(userAddress: userAddress) { data, response, error in
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
