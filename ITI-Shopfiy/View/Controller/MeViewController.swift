//
//  MeViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 24/02/2023.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var meView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //MARK: Conditions of view
        // condition: If user is logged
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
            let meLogedVC = (Bundle.main.loadNibNamed("MeLogedView", owner: self, options: nil)?.first as? MeLogedView)
            self.meView.addSubview(meLogedVC!)
            self.navigationController?.isNavigationBarHidden = false
            navigationItem.title = "User Name"
            meLogedVC?.meProtocol = self
        } // condition: If user is unlogged
        else{
            let meUnLogedVC = Bundle.main.loadNibNamed("MeUnlogedView", owner: self, options: nil)?.first as? MeUnlogedView
            meUnLogedVC?.guestImageView.image = UIImage(named: "person")
            self.navigationController?.isNavigationBarHidden = true
            self.meView.addSubview(meUnLogedVC!)
            meUnLogedVC?.meProtocol = self
        }
        

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        viewDidLoad()
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
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
            let settingsVC = UIStoryboard(name: "SettingsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "settings") as! SettingsViewController
            navigationController?.pushViewController(settingsVC, animated: true)
        }else{
            showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
        }
    }
    
    
    @IBAction func goToCartVC(_ sender: Any) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
            let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
            navigationController?.pushViewController(cartVC, animated: true)
        }else{
            showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
        }
    }
    

}



extension MeViewController: logedMeProtocol, unLogedMeProtocol{

    //MARK: LogedMe
    func goToAllOrders() {
        let ordersVC = UIStoryboard(name: "OrdersStoryboard", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersViewController
        self.navigationController?.pushViewController(ordersVC, animated: true)
    }
    
    func goToAllFavorites() {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        self.navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    
    //MARK: UnLogedMe
    func goToLogin() {
        let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func goToRegister() {
        let registerVC = UIStoryboard(name: "SignUpStoryboard", bundle: nil).instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func showLoginAlert(Title: String, Message: String) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertAction.Style.cancel, handler: { [self] action in
            let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
