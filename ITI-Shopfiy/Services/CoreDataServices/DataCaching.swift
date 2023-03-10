//
//  DataCaching.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 01/03/2023.
//


import Foundation
import CoreData
import UIKit

class DataCaching {
    static let sharedInstance = DataCaching()
    private init(){}
    
    //MARK: Fetch
    func fetchSavedProducts(userId: Int, appDelegate : AppDelegate) -> [Products] {
        var productArray: [Products] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.ProductEntity)
        fetchRequest.predicate = NSPredicate(format: "user_id = \(userId)")
        
        do {
            let fetchedProductArray = try managedContext.fetch(fetchRequest)
            for item in (fetchedProductArray)
            {
                let id = item.value(forKey:"product_id") as? Int
                let title = item.value(forKey: "title") as? String
                let src = item.value(forKey: "src") as? String
                let price = item.value(forKey: "price") as? String
                let product = Products(id: id, title: title, vendor: nil, body_html: nil, product_type: nil, created_at: nil, variants: nil, image: Image(src: src), images: nil, state: nil)
            productArray.append(product)
            }
            print(productArray.count)
        } catch let error {
            print("fetch all products error :", error)
        }
        return productArray
    }
    
    //MARK: Delete
    func deleteProductFromFavourites(userId: Int, appDelegate: AppDelegate, product_id: Int , complition : (Error?) -> Void?){
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ProductEntity)
            fetchRequest.predicate = NSPredicate(format: "product_id = \(product_id) AND user_id = \(userId)")
            let product = try managedContext.fetch(fetchRequest)
            
            managedContext.delete((product as! [NSManagedObject]).first!)
            
            try managedContext.save()
            print("\(product_id ) is Removed")
            complition(nil)
            
        } catch let error as NSError{
            complition("Error in deleting" as? Error )
            print("Error in deleting")
            print(error.localizedDescription)
        }
    }
    
    //MARK: Save
    func saveProductToFavourites(userId: Int, product : Products, appDelegate : AppDelegate) -> Void
    {
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.ProductEntity, in: managedContext)
        let Product = NSManagedObject(entity: entity!, insertInto: managedContext)
        Product.setValue(product.id ?? 0, forKey: "product_id")
        Product.setValue(product.title , forKey: "title")
        Product.setValue(product.image?.src , forKey: "src")
        Product.setValue(userId, forKey: "user_id")
        Product.setValue(product.variants?[0].price ?? "38", forKey: "price")
        Product.setValue(true , forKey: "product_state")
        do{
            try managedContext.save()
            print("\(Product.value(forKey: "title") ?? "Adidas") is Added")

        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    //MARK: Is Favorite
    func isFavouriteProduct (userId: Int, productID: Int, appDelegate : AppDelegate) -> Bool
    {
        var state : Bool = false
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.ProductEntity)
        fetchRequest.predicate = NSPredicate(format: "product_id = \(productID) AND user_id = \(userId)")
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
