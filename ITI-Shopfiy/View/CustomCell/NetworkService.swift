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
        
        guard let url = URL(string: URLService.produts(Brand_ID: Brand_ID)) else {
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
        guard let url = URL(string: URLService.productDetails(Product_ID: Product_ID)) else {
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
    static func fetchData(url: String?, completionHandler: @escaping (ProductResult?) -> Void) {
        guard let url = URL(string: "\(url!)") else {
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
