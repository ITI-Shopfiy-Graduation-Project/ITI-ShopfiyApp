//
//  ProductDetailsViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 27/02/2023.
//

import Foundation

class ProductDetailsVM{
    
    let databaseManager = CoreManager()
    func getProductsInFavourites(appDelegate: AppDelegate, product: inout Products) -> Bool {
        var isFavourite: Bool = false
        
        if !UserDefaultsManager.sharedInstance.getUserStatus() {
           
            return isFavourite
        }
        
        product.variants![0].id = UserDefaultsManager.sharedInstance.getUserID()!
        var productsArray = [Products]()
        databaseManager.getItemFromFavourites(appDelegate: appDelegate, product: product) { (products, error) in
            if let products = products {
                productsArray = products
            }
        }
        
        for item in productsArray {
            if item.id == product.id {
                isFavourite = true
            }
        }
      
        return isFavourite
    }
    
    
    func addProductToFavourites(appDelegate: AppDelegate, product: Products) {
        databaseManager.saveData(appDelegate: appDelegate, product: product)
    }
    
    func removeProductFromFavourites(appDelegate: AppDelegate, product: Products) {
        databaseManager.deleteProductFromFavourites(appDelegate: appDelegate, product: product)
    }
    
}
