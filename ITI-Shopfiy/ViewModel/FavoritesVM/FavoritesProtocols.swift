//
//  FavoritesProtocols.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 05/03/2023.
//

import Foundation

protocol FavoriteActionFavoritesScreen{
    func deleteFavourite(appDelegate: AppDelegate, product: Products) -> Void
}

protocol FavouriteActionProductScreen{
    func addFavourite(appDelegate: AppDelegate, product: Products) -> Void
    func deleteFavourite(appDelegate: AppDelegate, product: Products) -> Void
    func showAlert(title: String, message: String) -> Void
}
