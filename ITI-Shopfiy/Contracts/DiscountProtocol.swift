//
//  DiscountProtocol.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 04/03/2023.
//

import Foundation
protocol DiscountProtocol{
    static func discountfetchData(url : String?,handlerComplition : @escaping (DiscountCode?)->Void)
   
}
