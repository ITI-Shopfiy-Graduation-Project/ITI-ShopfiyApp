//
//  URLService.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 28/02/2023.
//

import Foundation

struct URLService{

    private static var baseUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/"

    static func customers() -> String {
        return baseUrl + "customers.json"
    }
    
    static func produts(Brand_ID: Int) -> String{
        return baseUrl + "collections/\(Brand_ID)/products.json"
    }
    
    static func productDetails(Product_ID: Int) -> String{
        return baseUrl + "products/\(Product_ID).json"
    }
    
    static func allProducts() -> String {
        return baseUrl + "products.json"
    }
    
    static func customCategory(category_ID: Int) -> String {
        return baseUrl + "custom_collections.json?ids=\(category_ID)"
    }
    
    static func allcategories() -> String {
        return baseUrl + "custom_collections.json"
    }
    
    static func postAddress(userID : Int) -> String{
        return baseUrl + "customers/\(userID)/addresses.json"
    }
    
    static func allUserAddress(userID: Int) -> String
    {
        return baseUrl + "customers/\(userID)/addresses.json"
    }
}
