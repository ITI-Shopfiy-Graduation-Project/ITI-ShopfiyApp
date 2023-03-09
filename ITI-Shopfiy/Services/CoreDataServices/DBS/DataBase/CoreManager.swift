//
//  DataBaseMannager.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 09/03/2023.
//

import Foundation

import Foundation
import CoreData
class CoreManager : CoreProtocol
{
    func saveData(appDelegate: AppDelegate, product: Products) {
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)
            
        let Product = NSManagedObject(entity: entity!, insertInto: managedContext)
        Product.setValue(product.id , forKey: "product_id")
        Product.setValue(product.variants![0].id , forKey: "user_id")
        Product.setValue(product.variants?[0].price ?? "0.0", forKey: "price")
        Product.setValue(product.title, forKey: "title")
        Product.setValue(product.images?[0].src, forKey: "src")
        do{
            try managedContext.save()
            print(" saved ")
        }catch let error as NSError{
            print("failed to save  \(error.localizedDescription)")
        }
    }
    
    func fetchData(appDelegate: AppDelegate, userId: Int, complition: @escaping ([Products]?, Error?) -> Void) {
        var favouriteList = [Products]()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "user_id = \(userId)")
        do{
            let productArray = try managedContext.fetch(fetchRequest)
            for product in productArray{
                let id = product.value(forKey: "product_id") as! Int
                let userID = product.value(forKey: "user_id") as! Int
                let price = product.value(forKey: "price") as! String
                let title = product.value(forKey: "title") as! String
                let image = product.value(forKey: "src") as! String
           

                let product = Products(id: id, title: title, variants: [variants(id: userID, option2: price)], images: [Image( src: image)])
            
                    favouriteList.append(product)
            }
            complition(favouriteList, nil)
        }catch{
            print("failed to fetch  \(error.localizedDescription)")
            complition(nil, error)
        }
    }
    
    func deleteProductFromFavourites(appDelegate: AppDelegate, product: Products) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
       fetchRequest.predicate = NSPredicate(format: "product_id = \(product.id) AND user_id = \(product.variants![0].id ?? 1)")
      do{
           let productsArray = try managedContext.fetch(fetchRequest)
           for product in productsArray {
             managedContext.delete(product)
          }
            try managedContext.save()
            print("deleted ")
        }catch{
            print("failed delete  \(error)")
        }
    }
    
    
    
    func getItemFromFavourites(appDelegate: AppDelegate, product: Products, complition: @escaping ([Products]?, Error?) -> Void) {
        var favouriteList = [Products]()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
        fetchRequest.predicate = NSPredicate(format: "product_id = \(product.id) AND user_id = \(product.variants![0].id ?? 1)")
        do{
            let productArray = try managedContext.fetch(fetchRequest)
      
            for product in productArray{
                let id = product.value(forKey: "product_id") as! Int
                let userID = product.value(forKey: "user_id") as! Int
                let price = product.value(forKey: "price") as! String
                let title = product.value(forKey: "title") as! String
                let imgUrl = product.value(forKey: "src") as! String
                
               
                let product = Products(id: id, title: title, variants: [variants(id: userID, option2: price)], images: [Image( src: imgUrl)])
                   
                    favouriteList.append(product)
            }
            complition(favouriteList, nil)
        }catch{
            print("failed fetching   \(error.localizedDescription)")
            complition(nil, error)
        }
    }
    
    
}
