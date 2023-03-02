//
//  ShoppingCart.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 02/03/2023.
//

import Foundation
class ShoppingCart : Codable{
    var draft_order: DrafOrder?
}

class DrafOrder : Codable {
    var id : Int?
    var email: String?
    var currency: String?
    var line_items : [LineItem]?
}

class LineItem : Codable {
    var id : Int?
    var product_id : Int?
    var title : String?
    var price : String?
    var quantity : Int?
    var image : String?
}
