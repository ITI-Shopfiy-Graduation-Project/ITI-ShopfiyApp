//
//  CoreDataProtocols.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 07/03/2023.
//

import CoreData
import Foundation

protocol SAVE_CORE {
    func saveData(Product: Products, userID: Int)
}

protocol FETCH_CORE {
    func fetchData(userID: Int) -> [NSManagedObject]
}

protocol DELETE_CORE {
    func deleteProductFromFavourites(product_id: Int, userID: Int)
}

//protocol IS_Favorite {
//    func isFavouriteProduct (productID: Int) -> Bool
//}
