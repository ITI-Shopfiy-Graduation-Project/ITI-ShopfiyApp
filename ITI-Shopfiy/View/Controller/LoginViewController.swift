//
//  LoginViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var username_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    var loginVM: LoginVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginVM = LoginVM()
        // Do any additional setup after loading the view.
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func login_btn(_ sender: Any) {
        let userName = username_txt.text ?? ""
        let password = password_txt.text ?? ""
        if ValdiateCustomerInfomation(UserName: userName, password: password){
            login(userName: userName, password: password)
        }else {
            showAlertError(title: "Couldnot register", message: "Please try again later.")
        }
        
    }
    
    
    @IBAction func signUp_btn(_ sender: Any) {
//        let leagueSB: UIStoryboard = UIStoryboard(name: "NewStoryboard", bundle: nil)
        let signUpVC: SignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func skip_btn(_ sender: Any) {
        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController
        UserDefaultsManager.sharedInstance.setUserStatus(userIsLogged: false)
        navigationController?.pushViewController(homeVC, animated: true)    }


}

extension LoginViewController{
    
    func ValdiateCustomerInfomation(UserName: String, password: String) -> Bool{
            
        var isSuccess = true
        self.loginVM?.validateCustomer(userName: UserName, password: password, completionHandler: { message in
            
            switch message {
            case "ErrorAllInfoIsNotFound":
                isSuccess = false
                self.showAlertError(title: "Missing Information", message: "please, enter all the required information.")
                
            case "ErrorPassword":
                isSuccess = false
                self.showAlertError(title: "Check Password", message: "please, enter password again.")
                


            default:
                self.showToastMessage(message: "Congratulations", color: UIColor(named: "Green") ?? .systemGreen)
                isSuccess = true
            }
        })
        return isSuccess
    }
    
    
    func login(userName: String, password: String){
        loginVM?.login(userName: userName, password: password, completionHandler: { Customer in
            if Customer != nil {
                UserDefaultsManager.sharedInstance.setUserStatus(userIsLogged: true)
                print("customer logged in successfully")
                //Navigation
                let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController
                self.navigationController?.pushViewController(homeVC, animated: true)
            }else{
                UserDefaultsManager.sharedInstance.setUserStatus(userIsLogged: false)
                self.showAlertError(title: "failed to login", message: "please check your email or password")
                print("failed to login")
            }
        })
    
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
