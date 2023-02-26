//
//  MeUnlogedView.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 26/02/2023.
//

import UIKit

class MeUnlogedView: UIView {
    weak var meProtocol: (unLogedMeProtocol)?

    
    @IBAction func goToOrders(_ sender: UIButton) {
        meProtocol?.goToAllOrdersfromUnLogedMe()
    }
    
    @IBAction func goToAllFavorites(_ sender: UIButton) {
        meProtocol?.goToAllFavoritesfromUnLogedMe()
    }
    
}
