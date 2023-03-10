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
    func setUserAddressID(userAddressID: Int?)
    func getUserAddressID()-> Int?
    func setUserStatus(userIsLogged: Bool)
    func getUserStatus()-> Bool
    func setFavorites(Favorites: Bool)
    func getFavorites()-> Bool
//    func setProductStatus(IsLiked: Bool)
//    func getProductStatus()-> Bool
    func getCurrency(key:String) -> String
    func setCurrency(key:String , value:String)
    func isLoggedIn()->Bool
    func login()
    func logut()
    
    //for products
    func isInFavouriteScreen()->Bool
    func LikesForProducts()
    func LikesForFavoriteScreen()
}

