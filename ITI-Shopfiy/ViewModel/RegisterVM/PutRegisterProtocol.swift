//
//  PutRegisterProtocol.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 01/03/2023.
//

import Foundation

protocol registerProtocol{
    func validateCustomer(userName:String, password:String,confirmPassword:String, userPhone:String,email:String, userAddress: Address?, completionHandler: @escaping (String?) ->Void)
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(password: String, confirmPassword: String) -> Bool
    func createNewCustomer(newCustomer: NewCustomer, completion:@escaping (Data?, HTTPURLResponse? , Error?)->())
    func saveCustomerDataToUserDefaults(customer: Dictionary<String,Any>?)
}
