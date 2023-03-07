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
    var results: [NSManagedObject]?
    
    var bindingFavorites: (() -> Void) = {}
    var savedResults: [Products]? {
        didSet {
            bindingFavorites()
        }
    }

}
   

extension FavouritesVM{
    
    func fetchSavedProducts(userID: Int){
        self.results = coreDataManager.fetchData(userID: userID)
        for item in (self.results ?? [])
        {
            
            let proudct = Products()
            
            proudct.id = item.value(forKey:"product_id") as? Int
            proudct.title = item.value(forKey: "title") as? String
            proudct.image?.src = item.value(forKey: "src") as? String
            proudct.variants?.first?.price = item.value(forKey: "price") as? String
            proudct.user_id = item.value(forKey: "user_id") as? Int
            self.savedResults?.append(proudct)
            print("AI")
        }
    }
    
    func saveProduct(product: Products, userId: Int){
        coreDataManager.saveData(Product: product, userID: userId)
        self.savedResults?.append(product)
    }
    
    func deleteProductItemFromFavourites (product_id: Int, userID: Int){
        self.results = coreDataManager.fetchData(userID: userID)
        for item in (self.results ?? [])
        {
            if (item.value(forKey: "user_id") as? Int == product_id){
                self.savedResults?.remove(at: product_id)
                print("AI")
            }
        }
    }

    
}
