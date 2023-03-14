//
//  LoginViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 01/03/2023.
//

import Foundation

class LoginVM: loginProtocol{
    
    func login(userName: String, password: String, completionHandler: @escaping (Customer?) -> Void) {
        CustomerLogin.login() { result in
            guard let customers = result?.customers else {return}
            var currentCustomer: Customer?
            for customer in customers {
                if (customer.email == userName) && (customer.tags == password) {
                    currentCustomer = customer
                }
            }
            if currentCustomer != nil{
                self.saveCustomerDataToUserDefaults(customer: currentCustomer!)
                completionHandler(currentCustomer)
            } else {
                completionHandler(nil)
            }
        }
  
    }
    
    
    func saveCustomerDataToUserDefaults(customer: Customer){
        guard let customerID = customer.id else {return}
        guard let userEmail = customer.email else {return}
        guard let userFirstName = customer.first_name else {return}
        guard let userPassword = customer.tags  else {return}
        guard let userPhone = customer.state  else {return}
        guard let userAddress = customer.addresses?[0].address1  else {return}
        guard let userAddressID = customer.addresses?[0].id  else {return}
        
        UserDefaultsManager.sharedInstance.setUserID(customerID: customerID)
        UserDefaultsManager.sharedInstance.setUserName(userName: userFirstName)
        UserDefaultsManager.sharedInstance.setUserEmail(userEmail: userEmail)
        UserDefaultsManager.sharedInstance.setUserPassword(userPassword: userPassword)
        //
        UserDefaultsManager.sharedInstance.setUserPhone(userPhone: userPhone)
        UserDefaultsManager.sharedInstance.setUserAddress(userAddress: userAddress)
        UserDefaultsManager.sharedInstance.setUserAddressID(userAddressID: userAddressID)
//
        UserDefaultsManager.sharedInstance.login()
    }
    
    func isValidPassword(password: String) -> Bool {
        return !password.isEmpty && password.count >= 4
    }
    
    

}
