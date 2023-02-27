//
//  UserDefaultsProtocol.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 01/03/2023.
//

import Foundation

protocol UserDefaultProtocol{
    func setUserID(customerID: Int?)
    func getUserID()-> Int?
    func setUserName(userName: String?)
    func getUserName()-> String?
    func setUserEmail(userEmail: String?)
    func getUserEmail()-> String?
    func setUserPhone(userPhone: String?)
    func getUserPhone()-> String?
    func setUserAddress(userAddress: String?)
    func getUserAddress()-> String?
    func setUserStatus(userIsLogged: Bool)
    func getUserStatus()-> Bool
    func getCurrency(key:String) -> String
    func setCurrency(key:String , value:String)
    func isLoggedIn()->Bool
    func login()
    func logut()
}
