//
//  MeViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 24/02/2023.
//

import UIKit
import Kingfisher
import Reachability

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
    var reachability:Reachability!


    @IBOutlet weak var meView: UIView!
    
    let meLogedVC = (Bundle.main.loadNibNamed("MeLogedView", owner: MeViewController.self, options: nil)?.first as? MeLogedView)
    
    let meUnLogedVC = Bundle.main.loadNibNamed("MeUnlogedView", owner: MeViewController.self, options: nil)?.first as? MeUnlogedView

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //MARK: Conditions of view
        // condition: If user is logged
        orderModel = GetOrderVM()
        orderModel?.getOrdersUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/orders.json?status=any"
        
        reachability = Reachability.forInternetConnection()

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
        self.navigationController!.navigationBar.tintColor = UIColor(named: "Green") ?? .green
        self.navigationItem.setHidesBackButton(true, animated: true)
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
                meLogedVC?.frame = self.meView.bounds
                self.meView.addSubview(meLogedVC!)
                //
                self.meLogedVC?.user_img.image = UIImage(named: "user")
                //user Image
                self.meLogedVC?.user_img.layer.cornerRadius = (self.meLogedVC?.user_img.frame.size.width ?? 0.0) / 2
                self.meLogedVC?.user_img.clipsToBounds = true
                self.meLogedVC?.user_img.layer.borderColor = UIColor.red.cgColor
                //
                self.meLogedVC?.userName_txt.text = UserDefaultsManager.sharedInstance.getUserName() ?? "Cristiano Ronaldo"
                //
                getSavedFavorites()
                self.navigationController?.isNavigationBarHidden = false
                navigationItem.title = "Profile"
                meLogedVC?.meProtocol = self
                orderModel?.getOrder()
                orderModel?.bindingOrder = {()in
                    self.renderOrders()
                    
                }
            } // condition: If user is unlogged
            else{
                self.meLogedVC?.removeFromSuperview()//to be removed
                meUnLogedVC?.guestImageView.image = UIImage(named: "person")
                self.navigationController?.isNavigationBarHidden = true
                meUnLogedVC?.frame = self.meView.bounds
                self.meView.addSubview(meUnLogedVC!)
                meUnLogedVC?.meProtocol = self
            }
        } // condition: If user is unlogged

        
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
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
                let settingsVC = UIStoryboard(name: "SettingsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "settings") as! SettingsViewController
                navigationController?.pushViewController(settingsVC, animated: true)
            }else{
                showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
            }
        }
    }
    
    
    @IBAction func goToCartVC(_ sender: Any) {
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
                if ((UserDefaultsManager.sharedInstance.getCartState() == true)){
                    let cartVC = UIStoryboard(name: "ShoppingCart", bundle: nil).instantiateViewController(withIdentifier: "shoppingCart") as! ShoppingCartViewController
                    navigationController?.pushViewController(cartVC, animated: true)
                }else {   self.showAlert(msg: "no products Added Yet")}}else{
                showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
            }
        }
        
    }
    

}



extension MeViewController: logedMeProtocol, unLogedMeProtocol{

    //MARK: LogedMe
    func goToAllOrders() {
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            if  addtoLine == nil {
                self.showAlert(msg: "No Orders")
            }
            else{
                let ordersVC = UIStoryboard(name: "OrdersStoryboard", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersViewController
                
                
                ordersVC.orderr = ordr
                self.navigationController?.pushViewController(ordersVC, animated: true)
                ordr.removeAll()
            }
        }
    }
    
    func goToAllFavorites() {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            if self.savedFavorites?.count == 0{
                self.showAlert(msg: "No Favorites yet")
            }else{
                self.navigationController?.pushViewController(favoritesVC, animated: true)
            }
        }
        
    }
    
    
    //MARK: UnLogedMe
    func goToLogin() {
        let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    func goToRegister() {
        let registerVC = UIStoryboard(name: "SignUpStoryboard", bundle: nil).instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    func showLoginAlert(Title: String, Message: String) {
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertAction.Style.cancel, handler: { [self] action in
                let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
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
//                    self.meLogedVC?.user_img.image = UIImage(named: "user")
//                    //user Image
//                    self.meLogedVC?.user_img.layer.cornerRadius = (self.meLogedVC?.user_img.frame.size.width ?? 0.0) / 2
//                    self.meLogedVC?.user_img.clipsToBounds = true
//                    self.meLogedVC?.user_img.layer.borderColor = UIColor.red.cgColor
//                    //
//                    self.meLogedVC?.userName_txt.text = UserDefaultsManager.sharedInstance.getUserName() ?? "Cristiano Ronaldo"

                    if self.savedFavorites?.count ?? 1 > 0{
                        self.meLogedVC?.productName_wishList.text = self.savedFavorites?[0].title
//                        self.meLogedVC?.productPrice_wishList.text = self.savedFavorites?[0].variants?[0].price
                        
                        if UserDefaultsManager.sharedInstance.getCurrency() == "EGP" {
                            let price = (Double(self.savedFavorites?[0].variants?[0].price ?? "0") ?? 0.0)  * 30
                            let priceString = "\(price.formatted()) EGP"
                            self.meLogedVC?.productPrice_wishList.text = priceString
                        }
                        else
                        {
                            let priceString = "\(self.savedFavorites?[0].variants?[0].price ?? "0") $"
                            self.meLogedVC?.productPrice_wishList.text = priceString
                        }
                        
                        self.meLogedVC?.productColor_wishList.text = self.savedFavorites?[0].variants?[0].option2
                        self.meLogedVC?.productImage_wishList.kf.setImage(with: URL(string:self.savedFavorites?[0].image?.src ?? ""))
                    }
                    //
                    else{
                        self.meLogedVC?.productName_wishList.text = "No Products yet"
                        self.meLogedVC?.productPrice_wishList.text =  "No Products yet"
                        self.meLogedVC?.productColor_wishList.text =  "No Products yet"
                        self.meLogedVC?.productImage_wishList.image = UIImage(named: "")
                        
                    }

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
                    self.meLogedVC?.Price.text = "estimited Delivery in 2 days"
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
