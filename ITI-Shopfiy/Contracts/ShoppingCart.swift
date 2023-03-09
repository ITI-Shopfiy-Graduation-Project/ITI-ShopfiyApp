//
//  ShoppingCart.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 02/03/2023.
//

import Foundation
class ShoppingCart : Codable{
    var draft_orders : [DrafOrder]?
    
}

struct DrafOrder : Codable {
    var id : Int?
    var email: String?
//    var currency: String?
//    var name : String?
    var line_items : [LineItem]?
//    var customer : customer?
//    var created_at: String?
//  var updated_at : String?
}

class LineItem : Codable {
//    var id : Int?
    var product_id : Int?
    var title : String?
    var price : String?
    var quantity : Int?
    var sku : String?
    var grams : Int?
    var vendor : String?
    


}
class customer : Codable{
    
    var id : Int?
    var email : String?
//               "accepts_marketing":false,
   var created_at: String?
 var updated_at : String?
var first_name : String?
    
    
    
    
    
}

struct ShoppingCartPut : Codable{
    var draft_order : DrafOrder?
}
