//
//  Order.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 11/03/2023.
//

import Foundation
struct Order : Decodable {
    
var orders : [OrderInfo]?
   
    
    
    
    
    
}
struct OrderInfo : Decodable {
    
  
    var id :Int?
    var confirmed: Bool?
    var contact_email:String?
    var created_at:String?
    var currency:String?
    var current_subtotal_price:String?
    var email : String?
    var current_total_discounts:String?
    var current_total_price :String?
    var number : Int?
    var order_number : Int?
    var order_status_url: String?
    
    
    
    
}
