//
//  CustomerProtocols.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 28/02/2023.
//

import Foundation
import Alamofire

protocol PUT_REGISTER{
    static func registerCustomer(newCustomer: NewCustomer, completionHandler:@escaping (Data?, URLResponse? , Error?)->())
}

protocol GET_LOGIN{
    static func login(completionHandler: @escaping (LoginResponse?) -> Void)
}
