//
//  MeUnlogedView.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 26/02/2023.
//

import UIKit

class MeUnlogedView: UIView {
    weak var meProtocol: (unLogedMeProtocol)?

    
    @IBAction func Login(_ sender: UIButton) {
        meProtocol?.goToLogin()
    }
    
    @IBAction func Register(_ sender: UIButton) {
        meProtocol?.goToRegister()
    }
    
}
