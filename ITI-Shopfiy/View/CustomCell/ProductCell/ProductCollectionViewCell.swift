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
    var isFavourite: Bool?
    var product: Products?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var productsView: FavouriteActionProductScreen?
    var favouritesView: FavoriteActionFavoritesScreen?
    var isInFavouriteScreen: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addToLikes(_ sender: UIButton) {
        if isInFavouriteScreen! {
            actionTakenInCellInFavouritesView()
        } else {
            actionTakenInCellInProductsView()
        }
    }

}

extension ProductCollectionViewCell{
    
    //cell is liked check
    func configureCell(product: Products, isFavourite: Bool, isInFavouriteScreen: Bool = false) {
        let imgLink = (product.image?.src) ?? ""
        let url = URL(string: imgLink)
        productImageview.kf.setImage(with: url)
        productTitle.text = product.title
        if isFavourite {
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.product = product
        self.isFavourite = isFavourite
        self.isInFavouriteScreen = isInFavouriteScreen
    }
    
    func actionTakenInCellInProductsView() {
        if UserDefaultsManager.sharedInstance.isLoggedIn() == false{
            productsView?.showAlert(title: "Alert",message: "You must login")
            return
        }
        
        if isFavourite! {
            productsView?.deleteFavourite(appDelegate: appDelegate, product: product!)
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            product?.user_id = UserDefaultsManager.sharedInstance.getUserID()!
            productsView?.addFavourite(appDelegate: appDelegate, product: product!)
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        isFavourite = !isFavourite!
    }
    
    func actionTakenInCellInFavouritesView() {
        favouritesView?.deleteFavourite(appDelegate: appDelegate, product: product!)
    }
    
    
}
