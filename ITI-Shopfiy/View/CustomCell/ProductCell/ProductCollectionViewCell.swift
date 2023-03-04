//
//  ProductCollectionViewCell.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    var product: Products?
    var delegate: ToAddToLikes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var isFavourite:Bool!{
        didSet{
            if isFavourite == true{
                like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    @IBAction func addToLikes(_ sender: UIButton) {
        //        let products = Products()
        //        addToLikes?.addToFavorites(Product: products, Button: like_btn)
        if (delegate?.isLogin() == true){
            if (delegate?.isFavourite(id: product?.id ?? 0) == true){
                print("\(product?.id ?? 0) is liked product")
                print("\(product?.title ?? "Adidas") is liked product")
                delegate?.deleteFromFavourites(id: product?.id ?? 0)
                like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
                print("UnLiked done")
                
            }else{
                delegate?.addToFavourite(product: product ?? Products())
                like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                print("Liked")
            }
            print("prdouct id: \(product?.id ?? 0)")
        }else{
            delegate?.navTologin()
        }
        
    }

}

protocol ToAddToLikes {
    func isFavourite(id: Int)->Bool
    func deleteFromFavourites(id: Int)
    func addToFavourite(product: Products)
    func isLogin()->Bool
    func navTologin()
}

