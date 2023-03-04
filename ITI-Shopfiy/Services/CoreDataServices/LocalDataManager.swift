//
//  LocalDataManager.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 01/03/2023.
//

import Foundation

class DataManager: IDataCaching {
    let dbManger = DataCaching.sharedInstance
    
    func fetchSavedProducts(appDelegate: AppDelegate, completion: @escaping (([Products]?, Error?) -> Void)) {
        completion(dbManger.fetchSavedProducts(appDelegate: appDelegate), "Fetching Saved Leagues Error" as? Error)
    }
    func deleteProductFromFavourites(appDelegate: AppDelegate, ProductID: Int, completion: (Error?) -> Void) {
        dbManger.deleteProductFromFavourites(appDelegate: appDelegate, product_id: ProductID ) { _ in
              
          }

    }
    
    func saveProductToFavourites(appDelegate: AppDelegate, product: Products) {
        dbManger.saveProductToFavourites(product: product, appDelegate: appDelegate)

    }
    
    func isFavourite(appDelegate: AppDelegate, productID: Int) -> Bool {
        dbManger.isFavouriteProduct(productID: productID,  appDelegate: appDelegate)

    }
    
}
