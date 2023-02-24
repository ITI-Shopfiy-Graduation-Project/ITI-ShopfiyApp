//
//  ProductCollectionViewCell.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var cart_btn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    

}
