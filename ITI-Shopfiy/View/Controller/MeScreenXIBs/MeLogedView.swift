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
    
    @IBAction func goToAllOrders(_ sender: UIButton) {
        meProtocol?.goToAllOrders()
    }
    
    
    @IBAction func goToAllFavorites(_ sender: UIButton) {
        meProtocol?.goToAllFavorites()
    }
    
    
}
