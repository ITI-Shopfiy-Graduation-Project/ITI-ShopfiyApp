//
//  FavoritesViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 04/03/2023.
//

import Foundation
import CoreData

class FavouritesVM {
    var managedContext: NSManagedObjectContext!
    var coreDataManager = CoreDataManager.getInstance()
    let userId = UserDefaultsManager.sharedInstance.getUserID()
    var results: [NSManagedObject] = []
    
    var bindingFavorites: (() -> Void) = {}
    var savedResults: [Products] = [] {
        didSet {
            bindingFavorites()
        }
    }

}
   

extension FavouritesVM{
    
    func fetchSavedProducts(userID: Int){
        self.results = coreDataManager.fetchData(userID: userID)
        for item in (self.results )
        {
//            let proudct = Products()
            for product in savedResults{
                product.id = item.value(forKey:"product_id") as? Int
                product.title = item.value(forKey: "title") as? String
                product.image?.src = item.value(forKey: "src") as? String
                product.variants?.first?.price = item.value(forKey: "price") as? String
                product.user_id = item.value(forKey: "user_id") as? Int
                //            self.savedResults?.append(proudct)
                print(product.title ?? "")
            }
        }
    }
    
    func deleteProductItemFromFavourites (product_id: Int, userID: Int){
        coreDataManager.deleteProductFromFavourites(product_id: product_id, userID: userID)
    }

    
}
