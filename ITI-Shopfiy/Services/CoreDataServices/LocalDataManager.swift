//
//  LocalDataManager.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 01/03/2023.
//

import Foundation

class DataManager: IDataCaching {
    let dbManger = DataCaching.sharedInstance
    
    func fetchSavedLeagues(appDelegate: AppDelegate, completion: @escaping (([Products]?, Error?) -> Void)) {
        completion(dbManger.fetchSavedLeagues(appDelegate: appDelegate), "Fetching Saved Leagues Error" as? Error)
    }
    func deleteLeagueFromFavourites(appDelegate: AppDelegate, ProductID: Int, completion: (Error?) -> Void) {
        dbManger.deleteLeagueFromFavourites(appDelegate: appDelegate, product_id: ProductID ) { _ in
              
          }

    }
    
    func saveLeagueToFavourites(appDelegate: AppDelegate, product: Products) {
        dbManger.saveLeagueToFavourites(product: product, appDelegate: appDelegate)

    }
    
    func isFavourite(appDelegate: AppDelegate, productID: Int) -> Bool {
        dbManger.isFavouriteLeague(productID: productID,  appDelegate: appDelegate)

    }
    
}
