//
//  ProductsViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 27/02/2023.
//

import Foundation

class ProductsVM{
    
    var bindingProducts: (([Products]?,Error?) -> Void) = {_, _ in }
    var productsResults :[Products]?{
        didSet{
            bindingProducts(productsResults,nil)
        }
    }
    
    var error: Error? {
        didSet {
            bindingProducts(nil, error)
        }
    }
    
    let dataCaching: IDataCaching
    init(dataCaching : IDataCaching = DataManager()) {
        self.dataCaching = dataCaching
    }
    
}


extension ProductsVM: getProductsProtocol{
    
    func getProducts(URL: String){
        ProductsService.fetchData(url: URL,completionHandler: { result in
            self.productsResults = result?.products
        })
    
    }
    
}

extension ProductsVM{
    
    func addFavourite(appDelegate: AppDelegate, product: Products) {
        self.dataCaching.saveProductToFavourites(appDelegate: appDelegate, product: product)
    }
    
    func deleteFavourite(appDelegate: AppDelegate, product: Products) {
        self.dataCaching.deleteProductFromFavourites(appDelegate: appDelegate, ProductID: product.id ?? 0) { errorMsg in
            if let error = errorMsg {
                self.error = error
            }
        }

    }
    
    func isProductsInFavourites(appDelegate: AppDelegate, product: Products) -> Bool {
        return self.dataCaching.isFavourite(appDelegate: appDelegate, productID: product.id ?? 0)
    }
    
    
    
    
}
