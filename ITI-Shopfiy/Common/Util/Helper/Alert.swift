//
//  Alert.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 27/02/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertForSettings(msg: String , type: String) {
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
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlert(msg: String ) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertForCart(msg: String)
    {
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .cancel , handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
            alert.addAction(UIAlertAction(title: "Add products", style: .default , handler: { action in
                let productsVC = UIStoryboard(name: "ProductsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "products") as! ProductsViewController
                self.navigationController?.pushViewController(productsVC, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
    }
}
