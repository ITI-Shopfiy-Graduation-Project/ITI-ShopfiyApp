//
//  Customer.swift
//  ITI-Shopfiy5 conflicts
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

    //state is the phone
    var first_name, state, tags: String?
    var email: String?
    var id: Int?
    var verified_email: Bool?
    var addresses: [Address]?
    var last_order_name : String?
    var currency: String?
//    var default_address: Address?

    init(first_name: String? = nil, state: String? = nil, tags: String? = nil, email: String? = nil, id: Int? = nil, verified_email: Bool? = nil, addresses: [Address]? = nil) {
        self.first_name = first_name
        self.state = state
        self.tags = tags
        self.email = email
        self.id = id
        self.verified_email = verified_email
        self.addresses = addresses
    }

}

class Address: Codable {
    var address1, address2, city, province, phone: String?
    var zip, first_name, country: String?
    var id, customer_id: Int?
//    var province_code: String?
//    var default_add = true
    }


//class PutAddress: Codable {
//    var customer: CustomerAddress?
//    init(customer: CustomerAddress? = nil) {
//        self.customer = customer
//    }
//}

  


class PutAddress: Codable {
    var customer: CustomerAddress?
    init(customer: CustomerAddress? = nil) {
        self.customer = customer
    }
}

class LoginResponse: Codable {
    var customers: [Customer]?
    init(customers: [Customer]? = nil) {
        self.customers = customers
    }
}

class CustomerAddress: Codable {
    var addresses: [Address]?

}


class PostAddress : Codable {
    var customer_address : Address?
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
