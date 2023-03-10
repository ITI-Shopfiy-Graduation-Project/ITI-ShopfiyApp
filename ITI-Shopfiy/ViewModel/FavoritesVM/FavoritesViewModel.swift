//
//  FavoritesViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 04/03/2023.
//

import Foundation

class FavouritesVM {
    var databaseManager = CoreManager()
    var favoritesArray: [Products]? {
        didSet {
            bindingData(favoritesArray, nil)
        }
    }

    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    var bindingData: (([Products]?,Error?) -> Void) = {_, _ in }

    func fetchfavorites(appDelegate: AppDelegate, userId: Int) {
        databaseManager.fetchData(appDelegate: appDelegate, userId: userId) { favorites, error in
            
            if let favorites = favorites {
                self.favoritesArray = favorites
            }
            
            if let error = error {
                self.error = error
            }
        }
    }
    
    func deleteFavourite(appDelegate: AppDelegate, product: Products){
        databaseManager.deleteProductFromFavourites(appDelegate: appDelegate, product: product)
    }

    
}
