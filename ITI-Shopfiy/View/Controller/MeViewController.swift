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
        
        //if unloged{
        let meUnLogedVC = Bundle.main.loadNibNamed("MeUnlogedView", owner: self, options: nil)?.first as? MeUnlogedView
        meUnLogedVC?.meProtocol = self
        self.meView.addSubview(meUnLogedVC!)
        //}else{
        //  let meLogedVC = Bundle.main.loadNibNamed("MeLogedView", owner: self, options: nil)?.first as? MeLogedView
//          meLogedVC?.meProtocol = self
//          self.meView.addSubview(meLogedVC!)
//          meLogedVC.user_img.image = UIImage(named: "")
        //}

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
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
    
//    //MARK: Alert
//    func showAlert() {
//        let alert = UIAlertController(title: "Not Allowed Authority", message: "You can login with your account first", preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "Login Now", style: UIAlertAction.Style.default, handler: { [self] action in
//            let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
//            self.navigationController?.pushViewController(loginVC, animated: true)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
//
//        present(alert, animated: true, completion: nil)
//    }
    
}
