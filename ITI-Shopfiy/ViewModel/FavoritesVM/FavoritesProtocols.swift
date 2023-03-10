//
//  FavoritesProtocols.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 05/03/2023.
//

import Foundation

protocol FavouriteActionProductScreen{

    func addFavourite(userId: Int, appDelegate: AppDelegate, product: Products)
    func isFavorite(userId: Int, appDelegate: AppDelegate, product: Products) -> Bool
    func showLoginAlert(title: String, message: String)
    func showAlert(userId: Int, appDelegate: AppDelegate, title: String, message: String, product: Products)
}

protocol FavoriteActionFavoritesScreen{
    func showAlert(userId: Int, appDelegate: AppDelegate, title: String, message: String, product: Products)
}
