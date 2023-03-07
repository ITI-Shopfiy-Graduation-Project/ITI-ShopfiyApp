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
    var Location: Bool = false
    var isLiked: Bool?
    var currentProduct: Products?{
        didSet{
            configureCell()
        }
    }
    
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
                actionTakenInCellInProductsView()
            }else{
                actionTakenInCellInFavoritesView()
            }
        }
        
    }

            


}

extension ProductCollectionViewCell{
//    cell is liked check
    func configureCell(){
        guard let currentProduct else { return }
        let imgLink = (currentProduct.image?.src) ?? ""
       let url = URL(string: imgLink)
       productImageview.kf.setImage(with: url)
       productTitle.text = currentProduct.title
        if ( isLiked == true ){
                like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }

    
    func actionTakenInCellInProductsView(){
        guard let currentProduct else { return }
        if (like_btn.image(for: .normal)) == UIImage(systemName: "heart.fill"){
                productsView?.showAlert(title: "Deleting From Favorites", message: "Are you sure ?", product: currentProduct)
            } else {
                productsView?.addFavourite(product: currentProduct)
                like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }

    }
    
    
    func actionTakenInCellInFavoritesView(){
        guard let currentProduct else { return }
        favouritesView?.showAlert(title: "Deleting From Favorites", message: "Are you sure ?", product: currentProduct)
    }
    
    
    
    


    
    
}
