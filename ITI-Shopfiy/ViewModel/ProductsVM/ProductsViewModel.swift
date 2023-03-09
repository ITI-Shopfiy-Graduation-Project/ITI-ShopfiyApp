//
//  ProductsViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 27/02/2023.
//

import Foundation

class ProductsVM{
    
    var bindingProducts: (() -> Void) = {}
    var productsResults: [Products]? {
        didSet {
            bindingProducts()
        }
    }
    var dataBaseManager = CoreManager()

}



extension ProductsVM: getProductsProtocol{
    
    func getProducts(URL: String){
        ProductsService.fetchData(url: URL,completionHandler: { result in
            self.productsResults = result?.products
        })
    
    }
    
    func addFavourite(appDelegate: AppDelegate, product: Products){
        dataBaseManager.saveData(appDelegate: appDelegate, product: product)
    }
    
    func deleteFavourite(appDelegate: AppDelegate, product: Products){
        dataBaseManager.deleteProductFromFavourites(appDelegate: appDelegate, product: product)
    }
    
    
}
    
