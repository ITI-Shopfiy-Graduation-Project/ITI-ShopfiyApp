//
//  CartProtocol.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 07/03/2023.
//

import Foundation
protocol CartProtocol {
    func postNewCart(userCart: [String:Any], completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ())
     func getCart()
}
