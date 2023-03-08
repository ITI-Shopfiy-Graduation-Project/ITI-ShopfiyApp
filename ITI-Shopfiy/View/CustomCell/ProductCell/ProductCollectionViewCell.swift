//
//  ProductCollectionViewCell.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit
import Kingfisher
import CoreData

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    var productsView: FavouriteActionProductScreen?
    var favouritesView: FavoriteActionFavoritesScreen?
    var Location: Bool?
    var currentProduct:Products?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addToLikes(_ sender: UIButton) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == false ){
            productsView?.showLoginAlert(title: "Alert",message: "You must login first")
        }
        else{
            if ( Location == false ){
                actionTakenInCellInProductsView(currentProduct: currentProduct ?? Products())
            }else{
                actionTakenInCellInFavoritesView(currentProduct: currentProduct ?? Products())
            }
        }
        
    }

            


}

extension ProductCollectionViewCell{
//    cell is liked check
    func configureCell(product: Products, isInFavouriteScreen: Bool = false){
        if isInFavouriteScreen == true{
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            if ( product.state == true ){
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else{
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
        self.Location = isInFavouriteScreen
        self.currentProduct = product
        }

    
    func actionTakenInCellInProductsView(currentProduct: Products){
        if (like_btn.image(for: .normal)) == UIImage(systemName: "heart.fill"){
                productsView?.showAlert(title: "Deleting From Favorites", message: "Are you sure ?", product: currentProduct)
            } else {
                productsView?.addFavourite(product: currentProduct)
                like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                currentProduct.state = true
            }

    }
    
    
    func actionTakenInCellInFavoritesView(currentProduct: Products){
        favouritesView?.showAlert(title: "Deleting From Favorites", message: "Are you sure ?", product: currentProduct)
    }
    
    
    
    


    
    
}
