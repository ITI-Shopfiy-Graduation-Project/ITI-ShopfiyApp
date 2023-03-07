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
//    var isLiked: Bool?
//    var product: Products? = Products()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var productsView: FavouriteActionProductScreen?
    var currentProduct = Products()
    var likedProducts: [NSManagedObject] = []
    var managedContext: NSManagedObjectContext!
    var coreDataObject: CoreDataManager?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addToLikes(_ sender: UIButton) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == false ){
            productsView?.showLoginAlert(title: "Alert",message: "You must login first")
        }
        else{
//            configureCell(product: currentProduct)
            actionTakenInCellInProductsView(product: currentProduct)
        }
        
    }

            


}

extension ProductCollectionViewCell{
//    cell is liked check
    func configureCell(product: Products){
        coreDataObject = CoreDataManager.getInstance()
        likedProducts = coreDataObject?.fetchData(userID: UserDefaultsManager.sharedInstance.getUserID() ?? -10) ?? []
       let imgLink = (product.image?.src) ?? ""
       let url = URL(string: imgLink)
       productImageview.kf.setImage(with: url)
       productTitle.text = product.title
        for Product in likedProducts {
            if (Product.value(forKey: "product_id") as? Int == product.id ){
                self.like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                print("yes")
            } else {
                like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }

    }

    
    func actionTakenInCellInProductsView(product: Products){

        if (self.like_btn.image(for: .normal)) == UIImage(systemName: "heart.fill"){
                productsView?.showAlert(title: "Deleting From Favorites", message: "Are you sure ?", product: product)
            } else {
                productsView?.addFavourite(product: product)
                like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
//        }

    }
    
    


    
    
}
