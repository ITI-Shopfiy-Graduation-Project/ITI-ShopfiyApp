//
//  GetLoginProtocol.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 01/03/2023.
//

import Foundation

protocol loginProtocol{
    func login(userName: String, password: String, completionHandler: @escaping (Customer?)-> Void)
    func isValidPassword(password: String) -> Bool
}
