//
//  ProductsProtocol.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 26/02/2023.
//

import Foundation
protocol ProductNetwork{
    static func fetchData(url : String?,handlerComplition : @escaping (ProductResult?)->Void)
   
}
