//
//  ProductsViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 27/02/2023.
//

import Foundation

class ProductsVM{
    
    var bindingProducts : (()->()) = {}
    var productsResults :[Products]?{
        didSet{
            bindingProducts()
        }
    }
    
}


extension ProductsVM: getProductsProtocol{
    
    func getProducts(Brand_ID: String){
        ProductsService.fetchData(completionHandler: { result in
            self.productsResults = result?.products
        }, Brand_ID: Brand_ID)
    
    }
    
    
    
    
}
