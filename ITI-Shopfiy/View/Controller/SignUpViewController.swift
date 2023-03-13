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
    
    //MARK: Errors
    @IBOutlet weak var userName_error: UILabel!
    @IBOutlet weak var email_error: UILabel!
    @IBOutlet weak var password_error: UILabel!
    @IBOutlet weak var confirmPassword_error: UILabel!
    @IBOutlet weak var phoneNumber_error: UILabel!
    @IBOutlet weak var address_error: UILabel!
    @IBOutlet weak var address_txt: UILabel!
    
    //MARK: Changes
    @IBAction func userName_changed(_ sender: Any) {
        if let name = username_txt.text{
            if let errorMessage = invalidName(name){
                userName_error.text = errorMessage
                userName_error.isHidden = false
            }else{
                userName_error.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    @IBAction func email_changed(_ sender: Any) {
        if let email = Email_txt.text{
            if let errorMessage = invalidEmail(email){
                email_error.text = errorMessage
                email_error.isHidden = false
            }else{
                email_error.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    @IBAction func password_changed(_ sender: Any) {
        if let password = password_txt.text{
            if let errorMessage = invalidPassword(password){
                password_error.text = errorMessage
                password_error.isHidden = false
            }else{
                password_error.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    @IBAction func confirmPassword_change(_ sender: Any) {
        if let confirmPassword = confirmPassword_txt.text{
            if let errorMessage = invalidConfirmPassword(confirmPassword){
                confirmPassword_error.text = errorMessage
                confirmPassword_error.isHidden = false
            }else{
                confirmPassword_error.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    @IBAction func phoneNumber_changed(_ sender: Any) {
        if let phoneNumber = phoneNumber_txt.text{
            if let errorMessage = invalidPhoneNumber(phoneNumber){
                phoneNumber_error.text = errorMessage
                phoneNumber_error.isHidden = false
            }else{
                phoneNumber_error.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    @IBOutlet weak var phoneNumber_txt: UITextField!
    @IBOutlet weak var createAccount_btn: UIButton!
    
    var registerVM: registerProtocol?
    var adresses: [Address]? = []
    var chosenAddress = Address()
    var indicator: UIActivityIndicatorView?

    //MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetForm()
        registerVM = RegisterVM()
        // Do any additional setup after loading the view.
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = view.center
        view.addSubview(indicator ?? UIActivityIndicatorView() )
        
        navigationItem.title = "Shopify App"
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
    }

    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkForValidForm()
    }
    
    
    @IBAction func chooseOnMap(_ sender: UIButton) {
        let addressVC = UIStoryboard(name: "AddressDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "addressDetails") as! ViewController
        addressVC.addressDelegate = self
        address_error.isHidden = true
        navigationController?.pushViewController(addressVC, animated: true)
        
    }
    
    @IBAction func createAccount_btn(_ sender: UIButton){
        guard let name = username_txt.text else {return}
        guard let email = Email_txt.text else {return}
        guard let password = password_txt.text else {return}
        guard let confirmPassword = confirmPassword_txt.text else {return}
        guard let phone = phoneNumber_txt.text else {return}
        
        indicator?.startAnimating()
        
        if ValdiateCustomerInfomation(UserName: name, password: password, confirmPassword: confirmPassword, userPhone: phone, email: email, userAddress: chosenAddress){
            register(UserName: name, password: password, confirmPassword: confirmPassword, UserPhone: phone, email: email, UserAddress: chosenAddress)
        } else {
            showAlertError(title: "Couldnot register", message: "Please try again later.")
            self.indicator?.stopAnimating()
        }
//        resetForm()
        
    }
    

}

extension SignUpViewController: AddressDelegate{
    func getAddressInfo(Address userAddress: Address) {
        self.adresses?.removeAll()
        self.adresses?.append(userAddress)
        self.chosenAddress = userAddress
        self.address_txt.text = userAddress.address1
        self.address_txt.isHidden = false
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
                self.indicator?.stopAnimating()
                
            case "ErrorPassword":
                isSuccess = false
                self.showAlertError(title: "Check Password", message: "please, enter password again.")
                self.indicator?.stopAnimating()
                
            case "ErrorEmail":
                isSuccess = false
                self.showAlertError(title: "Invalid Email", message: "please, enter another email.")
                self.indicator?.stopAnimating()
                
            default:
                self.showToastMessage(message: "Congratulations", color: UIColor(named: "Green") ?? .systemGreen)
                self.indicator?.stopAnimating()
                
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
                    self.indicator?.stopAnimating()
                    print(error?.localizedDescription ?? "errorssssss")
                }
                return
            }
            
            guard response?.statusCode != 422 else {
                DispatchQueue.main.async {
                    self.showAlertError(title: "Couldnot register", message: "Please, try another email.")
                    self.indicator?.stopAnimating()
                }
                return
            }
            
            //
            CustomerLogin.login(){ result in
                guard let customers = result?.customers else {return}
                for customer in customers {
                    if (newCustomer.customer?.id == customer.id){
                        let customerID = customer.id
                        UserDefaultsManager.sharedInstance.setUserID(customerID: customerID)
                        UserDefaultsManager.sharedInstance.setUserName(userName: UserName)
                        UserDefaultsManager.sharedInstance.setUserEmail(userEmail: email)
                        UserDefaultsManager.sharedInstance.setUserAddress(userAddress: UserAddress.address1)
                        
                    }
                    
                }}
            //
            
            DispatchQueue.main.async {
                print("registered successfully")
                self.resetForm()
                self.indicator?.stopAnimating()
                self.navigationController?.popViewController(animated: true)
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
    
    
    func resetForm(){
        createAccount_btn.isEnabled = false
        
        userName_error.isHidden = false
        email_error.isHidden = false
        password_error.isHidden = false
        confirmPassword_error.isHidden = false
        phoneNumber_error.isHidden = false
        address_txt.isHidden = true
        address_error.isHidden = false
        
        userName_error.text = "Required"
        email_error.text = "Required"
        password_error.text = "Required"
        confirmPassword_error.text = "Required"
        phoneNumber_error.text = "Required"
        address_error.text = "Required"
        
        username_txt.text = ""
        Email_txt.text = ""
        password_txt.text = ""
        confirmPassword_txt.text = ""
        phoneNumber_txt.text = ""
        address_txt.text = ""
    }
    
    
    func invalidPhoneNumber(_ value: String) -> String?{
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set){
            return "it must contain digits only"
        }
        if value.count != 11{
            return "Phone Number must be 11 Digits"
        }
        return nil
    }
    
    func  invalidName(_ value: String) -> String?{
        if value.count <= 2{
            return "It must be 3 at least like [ Ail ]"
        }
        return nil
    }
    
    func  invalidEmail(_ value: String) -> String?{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: value){
            return "Invalid Email address"
        }
        return nil
    }
    
    func invalidPassword(_ value: String) -> String?{
        if value.count <= 4{
            return "It must be 5 at least"
        }
        return nil
    }
    
    func invalidConfirmPassword(_ value: String) -> String?{
        if value != password_txt.text{
            return "It must be same as Password"
        }
        return nil
    }
    
    func checkForValidForm(){
        if email_error.isHidden && password_error.isHidden && phoneNumber_error.isHidden && confirmPassword_error.isHidden && userName_error.isHidden && address_error.isHidden{
            createAccount_btn.isEnabled = true
        }else{
            createAccount_btn.isEnabled = false
        }
    }
    
}

extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
