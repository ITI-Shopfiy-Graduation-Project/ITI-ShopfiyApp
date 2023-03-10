//
//  FavoritesProtocols.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 05/03/2023.
//

import Foundation

protocol FavouriteActionProductScreen{
//    func addFavourite(appDelegate: AppDelegate, product: Products) -> Void
//    func isFavorite(appDelegate: AppDelegate, product: Products) -> Bool
//    func showLoginAlert(title: String, message: String) -> Void
//    func showAlert(title: String, message: String, product: Products) -> Void

    func addFavourite(appDelegate: AppDelegate, product: Products)
//    func isFavorite(product: Products) -> Bool
    func showLoginAlert(title: String, message: String)
    func showAlert(appDelegate: AppDelegate, title: String, message: String, product: Products)
}

protocol FavoriteActionFavoritesScreen{
    func showAlert(appDelegate: AppDelegate, title: String, message: String, product: Products)
}
