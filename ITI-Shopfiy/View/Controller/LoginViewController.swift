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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func login_btn(_ sender: Any) {
    }
    
    @IBAction func signUp_btn(_ sender: Any) {
//        let leagueSB: UIStoryboard = UIStoryboard(name: "NewStoryboard", bundle: nil)
        let signUpVC: SignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func skip_btn(_ sender: Any) {
        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController
        navigationController?.pushViewController(homeVC, animated: true)    }


}
