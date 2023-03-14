//
//  SettingsViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 20/02/2023.
//

import UIKit
import Reachability

class SettingsViewController: UIViewController {

    @IBOutlet weak var currenceySegemnt: UISegmentedControl!
    @IBOutlet weak var username: UILabel!
    var reachability:Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reachability = Reachability.forInternetConnection()
        // Do any additional setup after loading the view.
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right
        if reachability.isReachable(){
            username.text = UserDefaultsManager.sharedInstance.getUserName()
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
        view.addGestureRecognizer(swipe)
    }
    override func viewWillAppear(_ animated: Bool) {
        if reachability.isReachable(){
            let currencey = UserDefaultsManager.sharedInstance.getCurrency()
            if currencey == "EGP" {
                currenceySegemnt.selectedSegmentIndex = 1
            }
            else
            {
                currenceySegemnt.selectedSegmentIndex = 0
            }
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
            
    }
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
/*
    @IBAction func action(_ sender: Any) {
        let meVC = UIStoryboard(name: "ShoppingCart", bundle: nil).instantiateViewController(withIdentifier: "shoppingCart") as! ShoppingCartViewController

        self.navigationController?.pushViewController(meVC, animated: true)
    }*/
    
    @IBAction func changePhone(_ sender: Any) {
        if reachability.isReachable(){
            let meVC = UIStoryboard(name: "ShoppingCart", bundle: nil).instantiateViewController(withIdentifier: "shoppingCart") as! ShoppingCartViewController
            
            self.navigationController?.pushViewController(meVC, animated: true)
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }
    
    @IBAction func changeCurrencey(_ sender: UISegmentedControl) {
        if reachability.isReachable(){
            let orderVM = OrderViewModel()
            switch sender.selectedSegmentIndex {
            case 0:
                print("USD")
                UserDefaultsManager.sharedInstance.setCurrency(key: "currency" , value: "USD")
                
            case 1:
                print("EGP")
                UserDefaultsManager.sharedInstance.setCurrency(key: "currency" , value: "EGP")
                orderVM.updateUserWithCoupon(coupon: "USD")
                
            default:
                UserDefaultsManager.sharedInstance.setCurrency(key: "currency" , value: "USD")
            }
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }
    @IBAction func logout_btn(_ sender: Any) {
        if reachability.isReachable(){
            showLogoutAlert(Title: "Do you want to Logout", Message: "We gonnna miss you")
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController{
    
    func showLogoutAlert(Title: String, Message: String) {
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.destructive, handler: { action in
                UserDefaultsManager.sharedInstance.logut()
                UserDefaultsManager.sharedInstance.setUserID(customerID: nil)
                UserDefaultsManager.sharedInstance.setUserCart(cartId: nil)
                UserDefaultsManager.sharedInstance.setUserName(userName: nil)
                UserDefaultsManager.sharedInstance.setUserAddress(userAddress: nil)
                UserDefaultsManager.sharedInstance.setUserAddressID(userAddressID: nil)
                UserDefaultsManager.sharedInstance.setUserEmail(userEmail: nil)
                UserDefaultsManager.sharedInstance.setUserPhone(userPhone: nil)
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
