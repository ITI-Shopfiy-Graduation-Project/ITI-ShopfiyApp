//
//  IAddressNetwork.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 03/03/2023.
//

import Foundation
protocol IAdressNetwork {
    func postAddress(userAddress: PostAddress, completionHandler:@escaping (Data?, URLResponse? , Error?)->())
}
