//
//  ProductsSearchViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 27/02/2023.
//

import Foundation

class ProductsSearchVM{
    
    var bindingProducts : (()->()) = {}
    var productsResults :[Products]?{
        didSet{
            bindingProducts()
        }
    }
    
}


extension ProductsSearchVM: getProductsSearchProtocol{
    func getProductsSearch(url: String) {
        ProductsSearchService.fetchData(url: url, completionHandler: { result in
            self.productsResults = result?.products
        })
    }
    
}
