//
//  PaymentViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var paymentView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentView.isUserInteractionEnabled = false
        paymentView.alpha = 0.3
        paymentView.backgroundColor = UIColor.gray

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GooglePay(_ sender: Any) {
    }
    @IBAction func applePay(_ sender: Any) {
    }
    
    @IBAction func cashOnDelivery(_ sender: Any) {
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
