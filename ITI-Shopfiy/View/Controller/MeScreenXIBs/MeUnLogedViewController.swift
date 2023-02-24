//
//  MeUnLogedViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 24/02/2023.
//

import UIKit

class MeUnLogedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let settingsScreen = UIBarButtonItem(image: UIImage(systemName: "wrench.adjustable.fill"), style: .plain, target: self, action: #selector(goToSettingsScreen(sender: )))
//        settingsScreen.tintColor = UIColor(named: "Green")
//
//        let cartScreen = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(goToCartScreen(sender: )))
//        cartScreen.tintColor = UIColor(named: "Green")
//        navigationItem.rightBarButtonItems = [settingsScreen, cartScreen]
    }

//    @objc func goToSettingsScreen(sender: AnyObject) {
//        //alert
//    }
//
//    @objc func goToCartScreen(sender: AnyObject) {
//        //alert
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
      
    
    @IBAction func goToOrders(_ sender: UIButton) {
        //alert
    }
    
    @IBAction func goToFavorites(_ sender: UIButton) {
        //alert
    }
    
    
    @IBAction func login_btn(_ sender: UIButton) {
    }
    
}
