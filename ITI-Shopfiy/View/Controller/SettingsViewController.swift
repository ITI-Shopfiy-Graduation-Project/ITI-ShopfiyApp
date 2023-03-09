//
//  SettingsViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 20/02/2023.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right
        username.text = UserDefaultsManager.sharedInstance.getUserName()
        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func changeCurrencey(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("USD")
            UserDefaultsManager.sharedInstance.setCurrency(key: "currency" , value: "USD")
        case 1:
            print("EGP")
            UserDefaultsManager.sharedInstance.setCurrency(key: "currency" , value: "EGP")
        default:
            UserDefaultsManager.sharedInstance.setCurrency(key: "currency" , value: "USD")
        }
        
    }
    @IBAction func logout_btn(_ sender: Any) {
        showLogoutAlert(Title: "Do you want to Logout", Message: "We gonnna miss you")
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
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.destructive, handler: { action in

            UserDefaultsManager.sharedInstance.logut()
            self.navigationController?.popViewController(animated: true)

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
