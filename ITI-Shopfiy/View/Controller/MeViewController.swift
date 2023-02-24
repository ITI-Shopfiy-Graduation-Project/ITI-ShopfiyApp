//
//  MeViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 24/02/2023.
//

import UIKit

class MeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goToSettingsVC(_ sender: Any) {
        let settingsVC = UIStoryboard(name: "SettingsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
    @IBAction func goToCartVC(_ sender: Any) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    

}
