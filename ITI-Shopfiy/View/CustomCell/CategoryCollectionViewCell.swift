//
//  CategoryCollectionViewCell.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 25/02/2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    var currentProduct: Products?
    var categoryDelegate: FavouriteActionCategoryScreen?
    @IBOutlet weak var price: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var like_btn: UIButton!
    
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == false ){
            categoryDelegate?.showLoginAlert(title: "UnAuthorized Action",message: "You must login first")
        }else{
            actionTakenInCellInCategoryView(currentProduct: currentProduct ?? Products())
        }

    }
    
    
}

extension CategoryCollectionViewCell{
    
    func actionTakenInCellInCategoryView(currentProduct: Products){
        if categoryDelegate?.isFavorite(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, product: currentProduct) == true{
            categoryDelegate?.showAlert(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, title: "Remove Item", message: "Are you suer ?", product: currentProduct)
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            categoryDelegate?.addFavourite(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, product: currentProduct)
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }

    }

}
