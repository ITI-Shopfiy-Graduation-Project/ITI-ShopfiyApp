//
//  PaymentViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit
import PassKit
import Braintree
class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var paymentView: UIStackView!
    var paymentRequest : PKPaymentRequest?
    var PaymentVM = PaymentViewModel()
    var braintreeClient: BTAPIClient!
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentView.isUserInteractionEnabled = false
        paymentView.alpha = 0.3
        paymentView.backgroundColor = UIColor.gray
        
        // Do any additional setup after loading the view.
        PaymentVM.bindPaymentResult = {
            self.getPaymentRequestToViewController()
        }
        //paypal token
        braintreeClient = BTAPIClient(authorization: "sandbox_4x759nm8_bmwnvznx5nj7n6dg")!
        
    }
    
    @IBAction func GooglePay(_ sender: Any) {
        setupPayPal()
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
        paymentRequest = PaymentVM.paymentRequest
    }
    
}
// MARK: - for Apple pay
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


// MARK: - for PayPal
extension PaymentViewController : BTViewControllerPresentingDelegate {
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    func setupPayPal(){
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        //    payPalDriver.viewControllerPresentingDelegate = self
        //   payPalDriver.appSwitchDelegate = self // Optional
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalCheckoutRequest(amount: "2.32")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.tokenizePayPalAccount(with: request){ tokenizedPayPalAccount, error in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                let email = tokenizedPayPalAccount.email
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName
                let phone = tokenizedPayPalAccount.phone
                
                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
            } else if error != nil {
                // Handle error here...
            } else {
                // Buyer canceled payment approval
            }
        }
    }
                                           
}


