//
//  PaymentViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var paymentView: UIStackView!
    var paymentRequest : PKPaymentRequest?
    var PaymentVM = PaymentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentView.isUserInteractionEnabled = false
        paymentView.alpha = 0.3
        paymentView.backgroundColor = UIColor.gray
        
        // Do any additional setup after loading the view.
        PaymentVM.bindPaymentResult = {
            self.getPaymentRequestToViewController()
        }
    }
    
    @IBAction func GooglePay(_ sender: Any) {
    }
    @IBAction func applePay(_ sender: Any) {
        showPaymentViewController()
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
extension PaymentViewController: IPaymentDelegate {
    
    func getPaymentRequestToViewController() {
        paymentRequest = { PaymentVM.getPaymentRequest() }()
    }
    
}
extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func showPaymentViewController(){
        guard let request = paymentRequest else {
            print("Error in payment request")
            return
            
        }
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
               if controller != nil {
                   controller!.delegate = self
                   present(controller!, animated: true, completion: nil)
               }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)

    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }
}
