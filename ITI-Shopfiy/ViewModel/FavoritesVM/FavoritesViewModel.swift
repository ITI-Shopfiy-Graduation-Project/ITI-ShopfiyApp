//
//  FavoritesViewModel.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 04/03/2023.
//

import Foundation

class FavouritesVM {
    
    var bindingData: (([Products]?,Error?) -> Void) = {_, _ in }
    
    var savedProductsArray:[Products]? {
        didSet {
            bindingData(savedProductsArray,nil)
        }
    }
    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    
    let dataCaching: IDataCaching
    init(dataCaching : IDataCaching = DataManager()) {
        self.dataCaching = dataCaching
    }
}
   

extension FavouritesVM{
    
    func fetchSavedProducts(appDelegate : AppDelegate){
        dataCaching.fetchSavedProducts(appDelegate: appDelegate) { result , error in
            if let products = result {
                self.savedProductsArray = products
            }
            if let error = error {
                self.error = error
            }
            
        }
    }
    
    
    func deleteProductItemFromFavourites (appDeleget : AppDelegate , ProductID: Int)
    {
        dataCaching.deleteProductFromFavourites(appDelegate: appDeleget, ProductID: ProductID) { errorMsg in
            if let error = errorMsg {
                self.error = error
            }
        }
    }
    
    
    func saveProduct(appDelegate: AppDelegate , product: Products)
    {
        dataCaching.saveProductToFavourites(appDelegate: appDelegate, product: product)
    }
    
    
    func isFavourite(appDelegate : AppDelegate , productID : Int) -> Bool
    {
        return dataCaching.isFavourite(appDelegate: appDelegate, productID: productID)
    }
    
    
}

//protocol baseProtocol {
//    func addProduct(product: Product)
//}

//protocol FavouriteViewModelTemp{
//    func addProduct(product: Product)
//    func isFavourite(id: Int)->Bool
//    func deleteFavourite(id: Int)
//    func addFavourite(product: Product)
//    func getAllFaourites()->[Product]
//    var favourites: [Product]{get}
//    var bindFavouritesList:()->(){set get}
//}
