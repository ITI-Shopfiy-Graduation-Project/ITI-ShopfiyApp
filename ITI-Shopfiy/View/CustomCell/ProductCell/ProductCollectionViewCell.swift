//
//  ProductCollectionViewCell.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var productsView: FavouriteActionProductScreen?
    var favouritesView: FavoriteActionFavoritesScreen?
    var Location: Bool?
    var currentProduct: Products?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addToLikes(_ sender: UIButton) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == false ){
            productsView?.showLoginAlert(title: "UnAuthorized Action",message: "You must login first")
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
    func actionTakenInCellInProductsView(currentProduct: Products){
        if productsView?.isFavorite(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, product: currentProduct) == true{
            productsView?.showAlert(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, title: "Remove Item", message: "Are you suer ?", product: currentProduct)
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            productsView?.addFavourite(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, product: currentProduct)
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }

    }
    
    
    func actionTakenInCellInFavoritesView(currentProduct: Products){
        favouritesView?.showAlert(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, title: "Remove Item", message: "Are you suer ?", product: currentProduct)
        
    }

    
    
}
