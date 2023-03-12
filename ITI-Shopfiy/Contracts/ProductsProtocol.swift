//
//  ProductsProtocol.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 26/02/2023.
//

import Foundation

//MARK: From Category
protocol ProductNetwork{
    static func fetchData(url : String?,handlerComplition : @escaping (ProductResult?)->Void)
}


//MARK: From Products
protocol GET_PRODUCTS {
    static func fetchData(url: String?, completionHandler: @escaping (ProductResult?)->Void)
}

//MARK: From Products Details
protocol GET_PRODUCTDETAILS{
    static func fetchData(completionHandler: @escaping (Products?)->Void, Product_ID: Int)
}
