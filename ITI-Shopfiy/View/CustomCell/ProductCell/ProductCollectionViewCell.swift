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
//    var isLiked: Bool?
    var product: Products?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var productsView: FavouriteActionProductScreen?


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addToLikes(_ sender: UIButton) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == false ){
            productsView?.showLoginAlert(title: "Alert",message: "You must login first")
            return
        }
        else{
            actionTakenInCellInProductsView(product: product ?? Products())
        }
        
    }

            


}

extension ProductCollectionViewCell{
    //cell is liked check
    func configureCell(product: Products) {
       let imgLink = (product.image?.src) ?? ""
       let url = URL(string: imgLink)
       productImageview.kf.setImage(with: url)
       productTitle.text = product.title
        if (productsView?.isFavorite(appDelegate: appDelegate, product: product) == false){
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    
    func actionTakenInCellInProductsView(product: Products) {
        
        if (productsView?.isFavorite(appDelegate: appDelegate, product: product) ==  false) {
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
            productsView?.showAlert(title: "Remove Item", message: "Are you sure ?", product: product)
//                    products.removeLast()
            print("Removed")
            }
        
        if (productsView?.isFavorite(appDelegate: appDelegate, product: product) ==  true){
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            productsView?.addFavourite(appDelegate: appDelegate, product: product)
//                    products.append(product)
            print("Added")
         }
        

    }
        

    
    
}
