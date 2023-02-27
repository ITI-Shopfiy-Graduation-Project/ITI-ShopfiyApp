//
//  NetworkService.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 26/02/2023.

//

import Foundation
import Alamofire

//MARK: From Category
class NetworkServices:ProductNetwork{
    static func fetchData(url : String?,handlerComplition : @escaping (ProductResult?)->Void) {
    AF.request("\(url!)").responseData {response in
            guard let data = response.data else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(ProductResult.self, from: data)
                handlerComplition(result)
            }catch let error {
                print(error.localizedDescription)
                handlerComplition(nil)
            }
            
          }
      }
    
}


//MARK: From Products
class ProductsService: GET_PRODUCTS{
    static func fetchData(completionHandler: @escaping (ProductResult?) -> Void, Brand_ID: Int) {
        
        guard let url = URL(string: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/collections/\(Brand_ID)/products.json") else {
            completionHandler(nil)
            return
        }
        AF.request(url).responseData {response in
                guard let data = response.data else {
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(ProductResult.self, from: data)
                    completionHandler(result)
                }catch let error {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
                
              }
        
    }
    
}

//MARK: From Products Details
class ProductDetailsService: GET_PRODUCTDETAILS{
    static func fetchData(completionHandler: @escaping (Products?) -> Void, Product_ID: Int) {
        guard let url = URL(string: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products/\(Product_ID).json") else {
            completionHandler(nil)
            return
        }
        AF.request(url).responseData {response in
                guard let data = response.data else {
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(ProductDetailsResult.self, from: data)
                    completionHandler(result.product)
                }catch let error {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
                
              }
    }
    
    
}

//MARK: From Products Search
class ProductsSearchService: GET_PRODUCTSSEARCH{
    static func fetchData(completionHandler: @escaping (ProductResult?) -> Void) {
        guard let url = URL(string: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json") else {
            completionHandler(nil)
            return
        }
        AF.request(url).responseData {response in
                guard let data = response.data else {
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(ProductResult.self, from: data)
                    completionHandler(result)
                }catch let error {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
                
              }
    }
    
    
    
    
}
