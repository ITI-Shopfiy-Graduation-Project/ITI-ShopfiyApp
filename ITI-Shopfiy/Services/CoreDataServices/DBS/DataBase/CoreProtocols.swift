//
//  DatabaseProtocols.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 09/03/2023.
//

import Foundation

protocol CoreProtocol
{
    func saveData(appDelegate: AppDelegate, product: Products)
    func fetchData(appDelegate: AppDelegate, userId: Int, complition: @escaping ([Products]?, Error?)->Void)
    func getItemFromFavourites(appDelegate: AppDelegate, product: Products, complition: @escaping ([Products]?, Error?)->Void)
    func deleteProductFromFavourites(appDelegate: AppDelegate, product: Products)
}
