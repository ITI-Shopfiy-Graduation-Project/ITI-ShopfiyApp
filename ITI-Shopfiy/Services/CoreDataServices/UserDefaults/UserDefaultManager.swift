//
//  UserDefaultManager.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 01/03/2023.
//

import Foundation

class UserDefaultsManager: UserDefaultProtocol{
    
    static let sharedInstance = UserDefaultsManager()
    
    private init() {
        
    }
    
    func setUserID(customerID: Int?){
        UserDefaults.standard.set(customerID, forKey: "User_ID")
    }
    
    func getUserID()-> Int?{
        return UserDefaults.standard.integer(forKey: "User_ID")
    }
    
    func setUserName(userName: String?){
        UserDefaults.standard.set(userName, forKey: "User_Name")
    }
    
    func getUserName()-> String?{
        return UserDefaults.standard.string(forKey: "User_Name")
    }
    
    func setUserPassword(userPassword: String?){
        UserDefaults.standard.set(userPassword, forKey: "User_Password")
    }
    
    func getUserPassword()-> String?{
        return UserDefaults.standard.string(forKey: "User_Password")
    }
    
    func setUserEmail(userEmail: String?){
        UserDefaults.standard.set(userEmail, forKey: "User_Email")
    }
    
    func getUserEmail()-> String?{
        return UserDefaults.standard.string(forKey: "User_Email")
    }
    
    func setUserPhone(userPhone: String?){
        UserDefaults.standard.set(userPhone, forKey: "User_Phone")
    }
    
    func getUserPhone()-> String?{
        return UserDefaults.standard.string(forKey: "User_Phone")
    }
    
    func setUserAddress(userAddress: String?){
        UserDefaults.standard.set(userAddress, forKey: "User_Address")
    }
    
    func getUserAddress()-> String?{
        return UserDefaults.standard.string(forKey: "User_Address")
    }
    
    func setUserStatus(userIsLogged: Bool){
        UserDefaults.standard.set(userIsLogged, forKey: "User_Status")
    }
    
    func getUserStatus()-> Bool{
        return UserDefaults.standard.bool(forKey: "User_Status")
    }
    
    func logut() {
        UserDefaults.standard.set(false, forKey: "IsLoggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsLoggedIn")
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: "IsLoggedIn")
    }
    
    func getCurrency(key: String = "currency") -> String {
        let currency = UserDefaults.standard.string(forKey: key)
        if currency == "" {
            return "USD"
        }
        return currency ?? "USD"
    }
    
    func setCurrency(key: String, value: String) {
        print(value)
        UserDefaults.standard.set(value, forKey: key)

    }
    
}
