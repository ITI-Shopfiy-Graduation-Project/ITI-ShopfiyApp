//
//  Customer.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 28/02/2023.
//

import Foundation

class NewCustomer: Codable {
    var customer: Customer?
    init(customer: Customer? = nil) {
        self.customer = customer
    }
}

class Customer: Codable {
    var first_name, phone, tags: String?
    var email: String?
    var id: Int?
    var verified_email: Bool?
    var addresses: [Address]?
//    var default_address: Address?
    init(first_name: String? = nil, phone: String? = nil, tags: String? = nil, email: String? = nil, id: Int? = nil, verified_email: Bool? = nil, addresses: [Address]? = nil) {
        self.first_name = first_name
        self.phone = phone
        self.tags = tags
        self.email = email
        self.id = id
        self.verified_email = verified_email
        self.addresses = addresses
    }
    
}

class Address: Codable {
    var address1, city, province, phone: String?
    var zip, first_name, country: String?
    var id, customer_id: Int?
//    var default_add = true
    init(address1: String? = nil, city: String? = nil, province: String? = nil, phone: String? = nil, zip: String? = nil, first_name: String? = nil, country: String? = nil, id: Int? = nil, customer_id: Int? = nil) {
        self.address1 = address1
        self.city = city
        self.province = province
        self.phone = phone
        self.zip = zip
        self.first_name = first_name
        self.country = country
        self.id = id
        self.customer_id = customer_id
    }
}

//class PutAddress: Codable {
//    var customer: CustomerAddress?
//    init(customer: CustomerAddress? = nil) {
//        self.customer = customer
//    }
//}

class LoginResponse: Codable {
    var customers: [Customer]?
    init(customers: [Customer]? = nil) {
        self.customers = customers
    }
}

struct CustomerAddress: Codable {
    var addresses: [Address]?
    init(addresses: [Address]? = nil) {
        self.addresses = addresses
    }
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
