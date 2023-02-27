//
//  Alert.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 27/02/2023.
//

import Foundation
import UIKit


func showAlert(msg: String , type: String) {
    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "close", style: .cancel))
    alert.addAction(UIAlertAction(title: "settings", style: .default , handler: { action in
        if type == "locationService"
        {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
           // UIApplication.shared.open(URL(string: "App-prefs:Privacy&path=LOCATION")!)

        }
        else if type == "authSettings" {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }))
}

func showAlert(msg: String ) {
    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "close", style: .cancel))
}