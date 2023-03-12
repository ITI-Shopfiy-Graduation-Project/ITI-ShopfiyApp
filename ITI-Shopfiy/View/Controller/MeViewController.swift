//
//  MeViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 24/02/2023.
//

import UIKit
import Kingfisher

class MeViewController: UIViewController {
    var savedFavorites: [Products]? = []
    var favoritesVM: FavouritesVM?
    var orderModel:GetOrderVM?
    var ordr :[OrderInfo] = []
    var ordrappend : OrderInfo?
    var cartcount = Order()
    var ordar = Order()
    var addtoLine : OrderInfo?
    var arr : [OrderInfo] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    @IBOutlet weak var meView: UIView!
    
    let meLogedVC = (Bundle.main.loadNibNamed("MeLogedView", owner: MeViewController.self, options: nil)?.first as? MeLogedView)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //MARK: Conditions of view
        // condition: If user is logged
        orderModel = GetOrderVM()
        orderModel?.getOrdersUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/orders.json?status=any"
        orderModel?.getOrder()
        orderModel?.bindingOrder = {()in
        self.renderOrders()
        
        }
   

        favoritesVM = FavouritesVM()
        
        viewWillAppear(false)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
       
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
//            let meLogedVC = (Bundle.main.loadNibNamed("MeLogedView", owner: self, options: nil)?.first as? MeLogedView)
       
            getSavedFavorites()
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
        if  addtoLine == nil {
            self.showAlert(msg: "No Orders")
        }
        else{
            let ordersVC = UIStoryboard(name: "OrdersStoryboard", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersViewController
          
            
            ordersVC.orderr = ordr
            self.navigationController?.pushViewController(ordersVC, animated: true)}
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

//MARK: Wish List
extension MeViewController{
    
    func getSavedFavorites(){
        favoritesVM?.fetchSavedProducts(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: self.appDelegate)
        favoritesVM?.bindingData = {result , error in
            if result != nil {
                DispatchQueue.main.async {
                    self.savedFavorites = result
                    self.savedFavorites  = self.favoritesVM?.savedProductsArray ?? []
                    self.meLogedVC?.user_img.image = UIImage(named: "user")
                    //user Image
                    self.meLogedVC?.user_img.layer.cornerRadius = (self.meLogedVC?.user_img.frame.size.width ?? 0.0) / 2
                    self.meLogedVC?.user_img.clipsToBounds = true
                    self.meLogedVC?.user_img.layer.borderColor = UIColor.red.cgColor
                    //
                    self.meLogedVC?.userName_txt.text = UserDefaultsManager.sharedInstance.getUserName() ?? "Cristiano Ronaldo"

                    if self.savedFavorites?.count ?? 1 > 0{
                        self.meLogedVC?.productName_wishList.text = self.savedFavorites?[0].title ?? "Adidas"
                        self.meLogedVC?.productPrice_wishList.text = self.savedFavorites?[0].variants?[0].price ?? "38.00"
                        self.meLogedVC?.productColor_wishList.text = self.savedFavorites?[0].variants?[0].option2 ?? "Black"
                        self.meLogedVC?.productImage_wishList.kf.setImage(with: URL(string:self.savedFavorites?[0].image?.src ?? ""))
                    }
                    //product Image

                    self.meLogedVC?.productImage_wishList.layer.cornerRadius = (self.meLogedVC?.productImage_wishList.frame.size.height ?? 250) / 2
                    self.meLogedVC?.productImage_wishList.clipsToBounds = true


                }
            }
            
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}
extension MeViewController {
    func renderOrders() {
        DispatchQueue.main.async {
            self.cartcount = (self.orderModel?.OrderResult)!
            self.cartcount.orders?.forEach({ emaill in
                
                if  emaill.email ==  UserDefaultsManager.sharedInstance.getUserEmail()!
                {  self.addtoLine = emaill
                    self.ordr.append(emaill)
                    self.meLogedVC?.email.text = emaill.email
                    self.meLogedVC?.Price.text = emaill.current_subtotal_price ?? "no" + " " + (emaill.currency!)
                    self.meLogedVC?.createdTime.text = emaill.created_at
                    self.meLogedVC?.orderId.text = String((emaill.id)!)
                }
               
                
            })
            if self.addtoLine == nil {
            
                   self.meLogedVC?.email.text = "No Order Yet"
                   self.meLogedVC?.Price.text = "0"
                   self.meLogedVC?.createdTime.text = "No Order yet"
                   self.meLogedVC?.orderId.text = "No Order yet"
            }
          
//            self.product = self.CategoryModel?.productsResults ?? []
          
        }
//        print (self.ordr[0].contact_email)
    }
    
    
    
    
    
    
    
}
