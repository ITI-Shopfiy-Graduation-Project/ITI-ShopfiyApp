//
//  IDataCaching.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 01/03/2023.
//

import Foundation
import CoreData
protocol IDataCaching{
  
    func fetchSavedProducts(userId: Int, appDelegate : AppDelegate, completion: @escaping(([Products]?, Error?) -> Void ))
    func deleteProductFromFavourites(userId: Int, appDelegate: AppDelegate, ProductID: Int , completion: (Error?) -> Void)
    func saveProductToFavourites(userId: Int, appDelegate : AppDelegate , product : Products) -> Void
    func isFavourite(userId: Int, appDelegate : AppDelegate, productID: Int) -> Bool

}
