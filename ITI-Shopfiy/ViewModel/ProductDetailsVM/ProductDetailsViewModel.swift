//
//  ProductDetailsViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 27/02/2023.
//

import Foundation

class ProductDetailsVM{
    
    var bindingProducts : (()->()) = {}
    var productsResults :Products?{
        didSet{
            bindingProducts()
        }
    }
    
}


extension ProductDetailsVM: getProductDetailsProtocol{
    func getProductDetails(Product_ID: Int) {
        ProductDetailsService.fetchData(completionHandler: { result in
            
            self.productsResults = result
        }, Product_ID: Product_ID)
    }
    
}
