//
//  CartViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 20/02/2023.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var codeError: UILabel!
    @IBOutlet weak var CartTable: UITableView!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var promoCodeET: UITextField!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var promoCodeValue: UILabel!
    @IBOutlet weak var allItemsCost: UILabel!
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
    
    
    @IBAction func applyPromoCode(_ sender: Any) {
    }
    
    @IBAction func proceedToCheckout(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
