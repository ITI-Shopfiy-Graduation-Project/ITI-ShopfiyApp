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


extension ProductsVM: getProductsSearchProtocol{
    func getProductsSearch() {
        ProductsSearchService.fetchData(completionHandler: { result in
            self.productsResults = result?.products
        })
    }
    
}
