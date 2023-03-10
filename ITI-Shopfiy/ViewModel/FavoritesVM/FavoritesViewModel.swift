//
//  FavoritesViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 04/03/2023.
//

import Foundation

import Foundation

class FavouritesVM {
    
    var bindingData: (([Products]?,Error?) -> Void) = {_, _ in }
    
    var savedProductsArray:[Products]? {
        didSet {
            bindingData(savedProductsArray,nil)
        }
    }
    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    
    let dataCaching: IDataCaching
    init(dataCaching : IDataCaching = DataManager()) {
        self.dataCaching = dataCaching
    }
}
   

extension FavouritesVM{

    func fetchSavedProducts(userId: Int, appDelegate : AppDelegate){
        dataCaching.fetchSavedProducts(userId: userId, appDelegate: appDelegate) { result , error in
            if let products = result {
                self.savedProductsArray = products
            }
            if let error = error {
                self.error = error
            }
        }
    }
    
    func deleteProductItemFromFavourites (userId: Int, appDeleget : AppDelegate , ProductID: Int)
    {
        dataCaching.deleteProductFromFavourites(userId: userId, appDelegate: appDeleget, ProductID: ProductID) { errorMsg in
            if let error = errorMsg {
                self.error = error
            }
        }
    }
    
    
    func addFavourite(userId: Int, appDelegate: AppDelegate, product: Products) {
        self.dataCaching.saveProductToFavourites(userId: userId, appDelegate: appDelegate, product: product)
    }
    
    func isProductsInFavourites(userId: Int, appDelegate: AppDelegate, product: Products) -> Bool {
        return self.dataCaching.isFavourite(userId: userId, appDelegate: appDelegate, productID: product.id ?? -1)
    }

    
}
