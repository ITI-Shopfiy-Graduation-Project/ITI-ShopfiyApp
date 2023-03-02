//
//  LoginViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 01/03/2023.
//

import Foundation

class LoginVM{
    
    var bindingCustomers : (()->()) = {}
    var loginResults :[Customer]?{
        didSet{
            bindingCustomers()
        }
    }
    
}
    

extension LoginVM: loginProtocol{
    
    func login(userName: String, password: String, completionHandler: @escaping (Customer?) -> Void) {
        CustomerLogin.login(user_name: userName,  password: password) { result in
            self.loginResults = result?.customers
            guard let customers = self.loginResults else {return}
            var currentCustomer: Customer?
            for customer in customers {
                if ((customer.first_name == userName) ) && customer.tags == password {
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
    
    func validateCustomer(userName: String, password: String, completionHandler: @escaping (String?) ->Void) {
        if (userName.isEmpty || userName.count <= 10) || (password.isEmpty || password.count <= 6){
            completionHandler("ErrorAllInfoIsNotFound")
            return
        }
        
        if !isValidPassword(password: password) {
            completionHandler("ErrorPassword")
            return
        }
    }
    
    
    func saveCustomerDataToUserDefaults(customer: Customer){
        guard let customerID = customer.id else {return}
        guard let userFirstName = customer.first_name else {return}
        guard let userEmail = customer.email  else {return}
        guard let userPassword = customer.tags  else {return}

        UserDefaultsManager.sharedInstance.setUserID(customerID: customerID)
        UserDefaultsManager.sharedInstance.setUserName(userName: userFirstName)
        UserDefaultsManager.sharedInstance.setUserEmail(userEmail: userEmail)
        UserDefaultsManager.sharedInstance.setUserPassword(userPassword: userPassword)
    }
    
    func isValidPassword(password: String) -> Bool {
        return !password.isEmpty && password.count >= 6
    }
    
    

}
