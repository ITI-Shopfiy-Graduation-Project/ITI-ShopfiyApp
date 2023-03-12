//
//  File.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 27/02/2023.
//

import Foundation
protocol BrandsProtocol{
    static func brandsfetchData(url : String?,handlerComplition : @escaping (BrandsResult?)->Void)
   
}
