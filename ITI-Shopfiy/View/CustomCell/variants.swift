//
//  File.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 26/02/2023.
//

import Foundation
class variants: Decodable{
    var id: Int?
    var product_id : Int?
    var inventory_item_id:Int?
    var price : String?
    var inventory_quantity : Int?
    var old_inventory_quantity:Int?
    var option1: String?
    var option2: String?
    var taxable: Bool?
    
    init(id: Int? = nil, product_id: Int? = nil, inventory_item_id: Int? = nil, price: String? = nil, inventory_quantity: Int? = nil, old_inventory_quantity: Int? = nil, option1: String? = nil, option2: String? = nil, taxable: Bool? = nil) {
        self.id = id
        self.product_id = product_id
        self.inventory_item_id = inventory_item_id
        self.price = price
        self.inventory_quantity = inventory_quantity
        self.old_inventory_quantity = old_inventory_quantity
        self.option1 = option1
        self.option2 = option2
        self.taxable = taxable
    }

}
