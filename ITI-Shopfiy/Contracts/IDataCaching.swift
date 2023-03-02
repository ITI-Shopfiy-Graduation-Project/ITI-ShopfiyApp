//
//  IDataCaching.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 01/03/2023.
//

import Foundation
import CoreData
protocol IDataCaching{
  
    func fetchSavedLeagues(appDelegate : AppDelegate, completion: @escaping(([Products]?, Error?) -> Void ))
    func deleteLeagueFromFavourites(appDelegate: AppDelegate, ProductID: Int , completion: (Error?) -> Void)
    func saveLeagueToFavourites(appDelegate : AppDelegate , product : Products) -> Void
    func isFavourite(appDelegate : AppDelegate, productID: Int) -> Bool

}
