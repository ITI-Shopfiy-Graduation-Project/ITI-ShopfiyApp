//
//  MeViewDelegate.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 25/02/2023.
//

import Foundation

protocol unLogedMeProtocol: AnyObject{
    func goToLogin()
    func goToRegister()
}


protocol logedMeProtocol: AnyObject{
    func goToAllOrders()
    func goToAllFavorites()
}
