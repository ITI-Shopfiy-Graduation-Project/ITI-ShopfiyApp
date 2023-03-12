//
//  NgetOrdersProtocol.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 11/03/2023.
//

import Foundation
protocol NgetOrdersProtocol{
    static func orderfetchData(url: String?, handlerComplition: @escaping (Order?) -> Void)
}
