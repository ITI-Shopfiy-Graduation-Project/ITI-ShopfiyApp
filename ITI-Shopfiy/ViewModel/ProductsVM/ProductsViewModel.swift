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
        dataCaching.saveProductToFavourites(appDelegate: appDelegate, product: product)
    }
    
    func deleteFavourite(appDelegate: AppDelegate, product: Products) {
        dataCaching.deleteProductFromFavourites(appDelegate: appDelegate, ProductID: product.id ?? 0) { errorMsg in
            if let error = errorMsg {
                self.error = error
            }
        }

    }
    
    func getProductsInFavourites(appDelegate: AppDelegate, product: inout Products) -> Bool {
        var isFavourite: Bool = false
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true) {
            return isFavourite
        }
        
        var productsArray = [Products]()
        product.user_id = UserDefaultsManager.sharedInstance.getUserID()!
        dataCaching.fetchSavedProducts(appDelegate: appDelegate) { (products, error) in
            if let products = products {
                productsArray = products
            }
        }

        for item in productsArray {
            if item.id == product.id {
                isFavourite = true
            }
        }
        return isFavourite
    }
    
}
