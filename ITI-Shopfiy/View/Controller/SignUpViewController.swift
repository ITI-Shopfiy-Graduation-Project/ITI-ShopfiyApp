//
//  SignUpViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import Foundation

class SignUpViewController: UIViewController {
    @IBOutlet weak var username_txt: UITextField!
    @IBOutlet weak var Email_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var confirmPassword_txt: UITextField!
    @IBOutlet weak var currentAddress_txt: UITextField!
    @IBOutlet weak var phoneNumber_txt: UITextField!
    @IBOutlet weak var createAccount_btn: UIButton!
    
    var registerVM: registerProtocol?
    var adresses: [Address]? = []
    var chosenAddress = Address()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerVM = RegisterVM()
        // Do any additional setup after loading the view.
        navigationItem.title = "Shopify App"
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }

    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func chooseOnMap(_ sender: UIButton) {
        let addressVC = UIStoryboard(name: "AddressDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "address") as! AddressViewController
        addressVC.addressDelegate = self
        navigationController?.pushViewController(addressVC, animated: true)
        
    }
    
    @IBAction func createAccount_btn(_ sender: UIButton){
        guard let name = username_txt.text else {return}
        guard let email = Email_txt.text else {return}
        guard let password = password_txt.text else {return}
        guard let confirmPassword = confirmPassword_txt.text else {return}
        guard let phone = phoneNumber_txt.text else {return}
        self.chosenAddress.address1 = currentAddress_txt.text
        self.adresses?.removeAll()
        self.adresses?.append(chosenAddress)
        
//        guard let address = currentAddress_txt.text else {return}
        if ValdiateCustomerInfomation(UserName: name, password: password, confirmPassword: confirmPassword, userPhone: phone, email: email, userAddress: chosenAddress){
            register(UserName: name, password: password, confirmPassword: confirmPassword, UserPhone: phone, email: email, UserAddress: chosenAddress)
        } else {
            showAlertError(title: "Couldnot register", message: "Please try again later.")
        }
        
    }
    

}

extension SignUpViewController: AddressDelegate{
    func getAddressInfo(Address userAddress: Address) {
        self.adresses?.removeAll()
        self.adresses?.append(userAddress)
        self.currentAddress_txt.text = userAddress.address1
    }
}

extension SignUpViewController {
    
    func ValdiateCustomerInfomation(UserName: String, password: String, confirmPassword: String, userPhone: String, email: String, userAddress: Address) -> Bool{
            
        var isSuccess = true
        self.registerVM?.validateCustomer(userName: UserName, password: password, confirmPassword: confirmPassword, userPhone: userPhone, email: email, userAddress: userAddress, completionHandler: { message in
            
            switch message {
            case "ErrorAllInfoIsNotFound":
                isSuccess = false
                self.showAlertError(title: "Missing Information", message: "please, enter all the required information.")
                
            case "ErrorPassword":
                isSuccess = false
                self.showAlertError(title: "Check Password", message: "please, enter password again.")
                
            case "InvalidUserName":
                isSuccess = false
                self.showAlertError(title: "Invalid User Name", message: "please, try another User Name.")
                
            case "ErrorEmail":
                isSuccess = false
                self.showAlertError(title: "Invalid Email", message: "please, enter correct email.")
                
            default:
                self.showToastMessage(message: "Congratulations", color: UIColor(named: "Green") ?? .systemGreen)

                isSuccess = true
            }
        })
        return isSuccess
    }
    
    func register(UserName: String, password: String, confirmPassword: String, UserPhone: String, email: String, UserAddress: Address){
        
        let customer = Customer(first_name: UserName,state: UserPhone, tags: password, email: email, addresses: self.adresses)
        let newCustomer = NewCustomer(customer: customer)
        self.registerVM?.createNewCustomer(newCustomer: newCustomer) { data, response, error in
                    
            guard error == nil else {
                DispatchQueue.main.async {
                    self.showAlertError(title: "Couldnot register", message: "Please, try again later.")
                }
                return
            }
            
            guard response?.statusCode != 422 else {
                DispatchQueue.main.async {
                    self.showAlertError(title: "Couldnot register", message: "Please, try another email.")
                }
                return
            }
                    
            print("registered successfully")
            
            DispatchQueue.main.async {
                let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController

                self.navigationController?.pushViewController(homeVC, animated: true)
//            let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
//
//            loginVC.modalPresentationStyle = .fullScreen
//            self.present(loginVC, animated: true, completion: nil)
            }
        }
            
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
