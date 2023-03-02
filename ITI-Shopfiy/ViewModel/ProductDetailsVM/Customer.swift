//
//  Customer.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 28/02/2023.
//

import Foundation

struct NewCustomer: Codable {
    var customer: Customer?
}

struct Customer: Codable {
    var first_name, phone, tags: String?
    var email: String?
    var id: Int?
    var verified_email: Bool?
    var addresses: [Address]?
    var default_address: Address?
    
}

struct Address: Codable {
    var address1, city, province, phone: String?
    var zip, first_name, country: String?
    var id, customer_id: Int?
    var default_add = true
}

struct PutAddress: Codable {
    var customer: CustomerAddress?
}

struct LoginResponse: Codable {
    var customers: [Customer]?
}

struct CustomerAddress: Codable {
    var addresses: [Address]?
}





//struct UpdateAddress: Codable {
//    var address: Address
//}
//
//struct OrderItem: Codable {
//    var variant_id, quantity: Int?
//    var name: String! = ""
//    var price: String!
//}
//
//struct OrderCustomer: Codable {
//    var id: Int
//    var first_name :String?
//    
//}
//
//struct Order: Codable {
//    var line_items: [OrderItem]
//    let customer: OrderCustomer
//    var financial_status: String = "paid"
//    var created_at :String?
//    var id : Int?
//    var currency:String?
//    var current_total_price:String?
//}
//
//struct APIOrder: Codable {
//    var order: Order
//}
//
//struct APIOrders: Codable {
//    var orders: [Order]
//}


extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
