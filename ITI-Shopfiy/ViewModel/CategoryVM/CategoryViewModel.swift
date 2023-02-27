//
//  File.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 26/02/2023.
//

import Foundation
class CategoryViewModel{
    var ProductsUrl : String?
    var bindingProducts : (()->()) = {}
    
    var productsResults :[Products]?{
        didSet{
            bindingProducts()
        }
    }
}
extension CategoryViewModel :getProductsFromCategoryProtocol
{
    func getProductsFromCategory() {
        NetworkServices.fetchData(url:ProductsUrl, handlerComplition: { result in
            self.productsResults =  result?.products
            
        })
    
    }
    
    
    
    
}

