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
    
    func fetchSavedProducts(userID: Int, appDelegate : AppDelegate) -> [Products] {
        var productArray: [Products] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.ProductEntity)
             fetchRequest.predicate = NSPredicate(format: "user_id == %i", userID )
        do {
            let fetchedProductArray = try managedContext.fetch(fetchRequest)
            for item in (fetchedProductArray)
            {
                
                let proudct = Products()
                
                proudct.id = item.value(forKey:"product_id") as? Int
                proudct.title = item.value(forKey: "title") as? String
                proudct.image?.src = item.value(forKey: "src") as? String
                proudct.variants?.first?.price = item.value(forKey: "price") as? String
                proudct.user_id = item.value(forKey: "user_id") as? Int
                productArray.append(proudct)
                print("AI")
            }
        } catch let error {
            print("fetch all products error :", error)
        }
        return productArray
    }
    
    func deleteProductFromFavourites(appDelegate: AppDelegate, product_id: Int , complition : (Error?) -> Void?){
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ProductEntity)
            fetchRequest.predicate = NSPredicate(format: "product_id == %i", product_id )
            let product = try managedContext.fetch(fetchRequest)
            
            managedContext.delete((product as! [NSManagedObject]).first!)
            
            try managedContext.save()
            print("Product deleted")
            print("me2mo")
            complition(nil)
        } catch let error as NSError{
            complition("Error in deleting" as? Error )
            print("Error in deleting")
            print(error.localizedDescription)
        }
    }
    
    func saveProductToFavourites(userID: Int, product : Products, appDelegate : AppDelegate) -> Void
    {
        let managedContext = appDelegate.persistentContainer.viewContext
        print("emann")
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)
        let Product = NSManagedObject(entity: entity!, insertInto: managedContext)
        Product.setValue(product.id ?? 0, forKey: "product_id")
        Product.setValue(product.title , forKey: "title")
        Product.setValue(product.image?.src , forKey: "src")
        Product.setValue(userID , forKey: "user_id")
//        Product.setValue(product.user_id ?? 0, forKey: "user_id")
        Product.setValue(product.variants?.first?.price, forKey: "price")
        Product.setValue(true , forKey: "product_state")
        do{
            try managedContext.save()
            print("Product Added!")
            print("fady")
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func isFavouriteProduct (productID: Int, appDelegate : AppDelegate) -> Bool
    {
        var state : Bool = false
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.ProductEntity)
        let pred = NSPredicate(format: "product_id == %i", productID )
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
