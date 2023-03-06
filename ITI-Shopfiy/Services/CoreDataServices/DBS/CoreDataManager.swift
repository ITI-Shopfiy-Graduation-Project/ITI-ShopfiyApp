//
//  CoreDataManager.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 07/03/2023.
//
import CoreData
import Foundation
import UIKit

class CoreDataManager: SAVE_CORE, FETCH_CORE, DELETE_CORE {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext: NSManagedObjectContext!
    let entity: NSEntityDescription!

    private static var coreDataObj: CoreDataManager?
    public static func getInstance() -> CoreDataManager {
        if let instance = coreDataObj {
            return instance

        } else {
            coreDataObj = CoreDataManager()
            return coreDataObj!
        }
    }

    private init() {
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)
    }
    
    
    func saveData(Product: Products, userID: Int) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext) else { return }
        let product = NSManagedObject(entity: entity, insertInto: managedContext)

        product.setValue(Product.id ?? 0, forKey: "product_id")
        product.setValue(Product.title , forKey: "title")
        product.setValue(Product.image?.src , forKey: "src")
        product.setValue(userID , forKey: "user_id")
        product.setValue(true , forKey: "product_state")
//        Product.setValue(product.user_id ?? 0, forKey: "user_id")
        product.setValue(Product.variants?.first?.price, forKey: "price")
        
        do {
            try managedContext.save()
            print("Saved!")
        } catch{
            print(error.localizedDescription)
        }
    }
    
    
    func fetchData(userID: Int) -> [NSManagedObject] {
        var products: [NSManagedObject]?
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
//            fetchRequest.predicate = NSPredicate(format: "user_id == %i", userID )
            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
                fetchRequest.predicate = NSPredicate(format: "user_id == %i", userID )
                products = try managedContext.fetch(fetchRequest)
            } catch let error {
                print(error.localizedDescription)
            }
        return products ?? []
    }
    
    
    func deleteProductFromFavourites(product_id: Int, userID: Int) {
        let products = fetchData(userID: userID)
        for product in products {
            if (product.value(forKey: "product_id") as! Int == product_id) {
                managedContext.delete(product)
                try? managedContext.save()
            }
        }
    }
    
//    func isFavouriteProduct (productID: Int) -> Bool {
//        var state : Bool = false
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
//        fetchRequest.predicate = NSPredicate(format: "product_id == %i", productID )
//            do{
//                let fetchedLeagueArray = try managedContext.fetch(fetchRequest)
//                for item in (fetchedLeagueArray)
//                {
//                    state = (item.value(forKey: "product_state") as? Bool ?? false)
//                    print("\(state)")
//                }
//            }catch let error{
//                print(error.localizedDescription)
//            }
//        
//        if state == true
//        {
//            return true
//        }
//        else
//        {
//            return false
//        }
//    }
    
    
}
