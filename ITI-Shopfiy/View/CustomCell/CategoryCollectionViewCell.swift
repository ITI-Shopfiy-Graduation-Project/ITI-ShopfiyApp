//
//  CategoryCollectionViewCell.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 25/02/2023.
//

import UIKit
import Foundation
class CategoryCollectionViewCell: UICollectionViewCell {
    @IBAction func addFavourite(_ sender: Any){
        
        buttonPressed(sender: addFav as Any)
        
    }
    
    @IBOutlet weak var addFav: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    var button: UIButton!
    var buttonAction: ((Any) -> Void)?
    @objc func buttonPressed(sender: Any) {
        self.buttonAction?(sender)
       }
    
    
}
