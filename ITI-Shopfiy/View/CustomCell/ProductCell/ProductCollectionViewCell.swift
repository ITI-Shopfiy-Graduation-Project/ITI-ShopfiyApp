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
    var isfavorite : Bool?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    func configureCell(product: Products, isLiked: Bool,   isInFavouriteScreen: Bool = false){
        if isLiked == true{
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            if ( product.state == true ){
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else{
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
        self.isfavorite = isLiked
        self.Location = isInFavouriteScreen
        self.currentProduct = product
        }

    func actionTakenInCellInProductsView(currentProduct: Products){
        if isfavorite! {
            productsView!.showAlert(appDelegate: appDelegate, title: "Remove Item", message: "Are you Sure ?", product: currentProduct)
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            currentProduct.variants![0].id = UserDefaultsManager.sharedInstance.getUserID()!
            productsView!.addFavourite(appDelegate: appDelegate, product: currentProduct)
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        isfavorite = !isfavorite!

    }
    
    
    func actionTakenInCellInFavoritesView(currentProduct: Products){
        favouritesView?.showAlert(appDelegate: appDelegate, title: "", message: "Remove Item", product: currentProduct)
    }
    
    
    
    


    
    
}
