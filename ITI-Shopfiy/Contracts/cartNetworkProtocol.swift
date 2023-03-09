//
//  cartNetworkProtocol.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 07/03/2023.
//

import Foundation
protocol cartNetworkProtocol{
    func postCart(userCart: [String:Any], completionHandler:@escaping (Data?, URLResponse? , Error?)->())
    static func CartfetchData(url : String?,handlerComplition : @escaping (ShoppingCart?)->Void)
    func putCart(userCart: ShoppingCartPut , completionHandler:@escaping (Data?, URLResponse? , Error?)->())
}
