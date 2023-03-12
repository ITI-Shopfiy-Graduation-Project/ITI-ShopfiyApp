//
//  RegisterViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 01/03/2023.
//

import Foundation

class RegisterVM: registerProtocol{

    func validateCustomer(userName: String, password: String, confirmPassword: String, userPhone: String, email: String, userAddress: Address?, completionHandler: @escaping (String?) ->Void) {
        //
            CustomerLogin.login(){ result in
                guard let customers = result?.customers else {return}
                for customer in customers {
                    if (email == customer.email){
                        completionHandler("ErrorEmail")
                        return
                    }
                    
                }}
            //
            if (userName.isEmpty && userName.count <= 2) && email.isEmpty && (password.isEmpty || password.count <= 4) || confirmPassword.isEmpty || userPhone.isEmpty {
                completionHandler("ErrorAllInfoIsNotFound")
                return
            }
                
//            if !self.isValidEmail(email) {
//                    completionHandler("ErrorEmail")
//                    return
//                }
                
            if !self.isValidPassword(password: password, confirmPassword: confirmPassword) {
                    completionHandler("ErrorPassword")
                    return
                }   
    }
    
    func createNewCustomer(newCustomer: NewCustomer, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
        
        CustomerRegister.registerCustomer(newCustomer: newCustomer){ data, response, error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }

            guard let data = data else {
                completion(nil, response as? HTTPURLResponse, error)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
            let customer = json["customer"] as? Dictionary<String,Any>
            self.saveCustomerDataToUserDefaults(customer: customer)
            completion(data, response as? HTTPURLResponse, nil)
        }
        
    }
    
    func saveCustomerDataToUserDefaults(customer: Dictionary<String, Any>?) {
        let customerID = customer?["id"] as? Int ?? 0
        let customerUserName = customer?["first_name"] as? String ?? ""
        let customerEmail = customer?["email"] as? String ?? ""
        let customerPhone = customer?["state"] as? String ?? ""
        let customerPassword = customer?["tags"] as? String ?? ""
        let customerAddress = customer?["addresses"] as? Dictionary<String, Any>
        let defaultAdress = customerAddress?["address1"] as? String ?? ""
        let defaultAdressID = customerAddress?["id"] as? Int ?? 0
        
        
        UserDefaultsManager.sharedInstance.setUserID(customerID: customerID)
        UserDefaultsManager.sharedInstance.setUserName(userName: customerUserName)
        UserDefaultsManager.sharedInstance.setUserPassword(userPassword: customerPassword)
        UserDefaultsManager.sharedInstance.setUserEmail(userEmail: customerEmail)
        UserDefaultsManager.sharedInstance.setUserPhone(userPhone: customerPhone)
        UserDefaultsManager.sharedInstance.setUserAddress(userAddress: defaultAdress)
        UserDefaultsManager.sharedInstance.setUserAddressID(userAddressID: defaultAdressID)
        UserDefaultsManager.sharedInstance.login()
    }
    
    func isValidPassword(password: String, confirmPassword: String) -> Bool {
        return (!password.isEmpty && !confirmPassword.isEmpty) && password == confirmPassword
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

