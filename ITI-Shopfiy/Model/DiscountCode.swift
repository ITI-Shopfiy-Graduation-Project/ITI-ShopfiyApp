//
//  DiscountCode.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 04/03/2023.
//

import Foundation
class DiscountCode : Codable {
    var discount_codes : [Discount]?
    

}
class Discount : Codable {
    
var code : String?
    
}
