//
//  LoginViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import Reachability

class LoginViewController: UIViewController {
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var username_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var validationLabel: UILabel!

    var loginVM: loginProtocol?

    var indicator: UIActivityIndicatorView?
    var reachability:Reachability!

    var cartVM = ShoppingCartViewModel()
    var AllDraftsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/draft_orders.json"
    var cartcount = ShoppingCart()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginVM = LoginVM()
        reachability = Reachability.forInternetConnection()
        
        // Do any additional setup after loading the view.
        if reachability.isReachable(){
            indicator = UIActivityIndicatorView(style: .large)
            indicator?.center = view.center
            view.addSubview(indicator ?? UIActivityIndicatorView() )
            
            self.loginImageView.image = UIImage(named: "logo")
            navigationItem.title = "Shopify App"
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
            swipe.direction = .right
            
            view.addGestureRecognizer(swipe)
            cartVM.cartsUrl = self.AllDraftsUrl
            cartVM.getCart()
            cartVM.bindingCartt = {()in
                self.renderCart()
                
            }
            getCartId()
            
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func login_btn(_ sender: Any) {
        if reachability.isReachable(){
            let userName = username_txt.text ?? ""
            let password = password_txt.text ?? ""
            indicator?.startAnimating()
            login(userName: userName, password: password)
            getCartId()
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    @IBAction func signUp_btn(_ sender: Any) {
        let signUpVC = UIStoryboard(name: "SignUpStoryboard", bundle: nil).instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        if reachability.isReachable(){
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }
    
    @IBAction func skip_btn(_ sender: Any) {
        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController
        if reachability.isReachable(){
            UserDefaultsManager.sharedInstance.logut()
            navigationController?.pushViewController(homeVC, animated: true)
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }


}

extension LoginViewController{
    
    func login(userName: String, password: String){
        loginVM?.login(userName: userName, password: password, completionHandler: { Customer in
            if Customer?.email == userName && Customer?.tags == password{
                self.showToastMessage(message: "Congratulations", color: UIColor(named: "Green") ?? .systemGreen)
                print("customer logged in successfully")
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showAlertError(title: "failed to login", message: "please check your Email or Password")
                print("failed to login")
            }
        })
        self.indicator?.stopAnimating()
    
    }
    
    func showAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(Action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToastMessage(message: String, color: UIColor) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 120, y: view.frame.height - 130, width: 260, height: 30))

        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = color
        toastLabel.textColor = .black
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
}


extension LoginViewController {
    func renderCart() {
        DispatchQueue.main.async {
            self.cartcount = self.cartVM.cartResult!
        }
  
    }
    
}

extension LoginViewController {
    func getCartId()
    {
        
        cartcount.draft_orders?.forEach({ email in
            
            if  email.email ==  username_txt.text ?? ""
            {
                UserDefaultsManager.sharedInstance.setUserCart(cartId: email.id)
                UserDefaultsManager.sharedInstance.setCartState(cartState: true)

            }
            else {
                UserDefaultsManager.sharedInstance.setCartState(cartState: false)
            }
            
            
            
        })}
                                        }


extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
