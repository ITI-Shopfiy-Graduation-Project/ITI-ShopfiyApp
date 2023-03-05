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
                if (customer.first_name == userName) && (customer.tags == password) {
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
        guard let userFirstName = customer.first_name else {return}
        guard let userPassword = customer.tags  else {return}
        
        UserDefaultsManager.sharedInstance.setUserID(customerID: customerID)
        UserDefaultsManager.sharedInstance.setUserName(userName: userFirstName)
        UserDefaultsManager.sharedInstance.setUserPassword(userPassword: userPassword)
        UserDefaultsManager.sharedInstance.login()
    }
    
    func isValidPassword(password: String) -> Bool {
        return !password.isEmpty && password.count >= 6
    }
    
    

}
