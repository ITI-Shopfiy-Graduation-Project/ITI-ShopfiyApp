//
//  IDataCaching.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 01/03/2023.
//

import Foundation
import CoreData
protocol IDataCaching{
  
    func fetchSavedProducts(appDelegate : AppDelegate, completion: @escaping(([Products]?, Error?) -> Void ))
    func deleteProductFromFavourites(appDelegate: AppDelegate, ProductID: Int , completion: (Error?) -> Void)
    func saveProductToFavourites(appDelegate : AppDelegate , product : Products) -> Void
    func isFavourite(appDelegate : AppDelegate, productID: Int) -> Bool

}
