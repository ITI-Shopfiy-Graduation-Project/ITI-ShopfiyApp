//
//  DataCaching.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 01/03/2023.
//


import Foundation
import CoreData

class DataCaching {
    static let sharedInstance = DataCaching()
    private init(){}
    
    func fetchSavedLeagues(appDelegate : AppDelegate) -> [Products] {
        var productArray: [Products] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.ProductEntity)
        
        do {
            let fetchedLeagueArray = try managedContext.fetch(fetchRequest)
            for item in (fetchedLeagueArray)
            {
                let proudct = Products()
                proudct.id = item.value(forKey:"league_id") as? Int
                proudct.title = item.value(forKey: "title") as? String
                proudct.image?.src = item.value(forKey: "src") as? String
                proudct.variants?.first?.price = item.value(forKey: "price") as? String
                proudct.user_id = item.value(forKey: "user_id") as? Int
                productArray.append(proudct)
            }
        } catch let error {
            print("fetch all leagues error :", error)
        }
        return productArray
    }
    
    func deleteLeagueFromFavourites(appDelegate: AppDelegate, product_id: Int , complition : (Error?) -> Void?){
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ProductEntity)
            fetchRequest.predicate = NSPredicate(format: "product_id == %i", product_id )
            let product = try managedContext.fetch(fetchRequest)
            
            managedContext.delete((product as! [NSManagedObject]).first!)
            
            try managedContext.save()
            print("product deleted")
            complition(nil)
        } catch let error as NSError{
            complition("Error in deleting" as? Error )
            print("Error in deleting")
            print(error.localizedDescription)
        }
    }
    
    func saveLeagueToFavourites(product : Products, appDelegate : AppDelegate) -> Void
    {
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.ProductEntity, in: managedContext)
        let league = NSManagedObject(entity: entity!, insertInto: managedContext)
        league.setValue(product.id ?? 0, forKey: "league_id")
        league.setValue(product.title , forKey: "title")
        league.setValue(product.image?.src , forKey: "src")
        league.setValue(product.user_id ?? 0, forKey: "user_id")
        league.setValue(product.variants?.first?.price, forKey: "price")
        league.setValue(true , forKey: "product_state")
        do{
            try managedContext.save()
            print("Saved!")
        }catch let error{
            print(error.localizedDescription)
        }
    }
    func isFavouriteLeague (productID: Int, appDelegate : AppDelegate) -> Bool
    {
        var state : Bool = false
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.ProductEntity)
        let pred = NSPredicate(format: "league_id == %i", productID )
        fetchRequest.predicate = pred
            do{
                let fetchedLeagueArray = try managedContext.fetch(fetchRequest)
                for item in (fetchedLeagueArray)
                {
                    state = (item.value(forKey: "product_state") as? Bool ?? false)
                    print("\(state)")
                }
            }catch let error{
                print(error.localizedDescription)
            }
        
        if state == true
        {
            return true
        }
        else
        {
            return false
        }
    }

    
}
