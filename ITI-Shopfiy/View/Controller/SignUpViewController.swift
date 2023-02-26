//
//  SignUpViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var username_txt: UITextField!
    @IBOutlet weak var phoneOrEmail_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var termsAndConditions_btn: UIButton!
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
    
    @IBAction func createAccount_btn(_ sender: UIButton){
        
    }
    


}
