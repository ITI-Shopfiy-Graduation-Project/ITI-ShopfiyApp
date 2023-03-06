//
//  LocalDataManager.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 01/03/2023.
//

import Foundation

class DataManager: IDataCaching {
    let dbManger = DataCaching.sharedInstance
    
    func fetchSavedProducts(userID: Int, appDelegate: AppDelegate, completion: @escaping (([Products]?, Error?) -> Void)) {
        completion(dbManger.fetchSavedProducts(userID: userID, appDelegate: appDelegate), "Fetching Saved Products Error" as? Error)
    }
    func deleteProductFromFavourites(appDelegate: AppDelegate, ProductID: Int, completion: (Error?) -> Void) {
        dbManger.deleteProductFromFavourites(appDelegate: appDelegate, product_id: ProductID ) { _ in
              
          }

    }
    
    func saveProductToFavourites(userID: Int, appDelegate: AppDelegate, product: Products) {
        dbManger.saveProductToFavourites(userID: userID, product: product, appDelegate: appDelegate)
    }
    
    func isFavourite(appDelegate: AppDelegate, productID: Int) -> Bool {
        dbManger.isFavouriteProduct(productID: productID,  appDelegate: appDelegate)

    }
    
}
