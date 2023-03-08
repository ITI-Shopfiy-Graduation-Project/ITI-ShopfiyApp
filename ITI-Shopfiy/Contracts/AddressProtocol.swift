//
//  AddressProtocol.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 03/03/2023.
//

import Foundation
protocol AddressProtocol {
    func postNewAddress(userAddress: PostAddress, completion:@escaping (Data?, HTTPURLResponse? , Error?)->())
    func getAllUserAddress(userId: Int)
}
