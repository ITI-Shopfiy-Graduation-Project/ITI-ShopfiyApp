//
//  MeLogedView.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 26/02/2023.
//

import UIKit

class MeLogedView: UIView {

    var meProtocol: logedMeProtocol?
    @IBOutlet weak var user_img: UIImageView!
    
    @IBOutlet weak var userName_txt: UILabel!
    
    @IBOutlet weak var productName_wishList: UILabel!
    @IBOutlet weak var productPrice_wishList: UILabel!
    @IBOutlet weak var productColor_wishList: UILabel!
    @IBOutlet weak var productImage_wishList: UIImageView!

    
    
    
    @IBAction func goToAllOrders(_ sender: UIButton) {
        meProtocol?.goToAllOrders()
    }
    
    
    @IBAction func goToAllFavorites(_ sender: UIButton) {
        meProtocol?.goToAllFavorites()
    }
    
    
}
