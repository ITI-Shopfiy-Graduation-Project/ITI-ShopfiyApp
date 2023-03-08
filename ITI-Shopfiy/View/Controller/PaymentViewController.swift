//
//  PaymentViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit
import PassKit
import Braintree
import BraintreeDropIn
import TTGSnackbar
class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var cash_btn: UIButton!
    @IBOutlet weak var paypal_btn: UIButton!
    @IBOutlet weak var apple_btn: UIButton!
    @IBOutlet weak var paymentView: UIStackView!
    var paymentRequest : PKPaymentRequest?
    var PaymentVM = PaymentViewModel()
    var braintreeClient: BTAPIClient!
    override func viewDidLoad() {
        super.viewDidLoad()
       // paymentView.isUserInteractionEnabled = false
       // paymentView.alpha = 0.3
       // paymentView.backgroundColor = UIColor.gray
        
        // Do any additional setup after loading the view.
        PaymentVM.bindPaymentResult = {
            self.getPaymentRequestToViewController()
        }
        //paypal token sandbox_mf932tgj_bmwnvznx5nj7n6dg
        //"sandbox_jyvqscf2_jpbyz2k4fnvh6fvt"
        braintreeClient = BTAPIClient(authorization: "sandbox_q7ftqr99_7h4b4rgjq3fptm87")!
        
    }
    
    @IBAction func GooglePay(_ sender: Any) {
        DispatchQueue.main.async {
            self.setupPayPal()
        }//showDropIn(clientTokenOrTokenizationKey: "sandbox_jyvqscf2_jpbyz2k4fnvh6fvt")
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
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR : \(String(describing: error?.localizedDescription))" )
            } else if (result?.isCanceled == true) {
                print("CANCELED")
            } else if let result = result {
                print("nonce : \(result.paymentMethod?.nonce ?? "payment method")")
                print("paymentType : \(result.paymentMethod?.type ?? "payment method")")
                print("Description : \(result.paymentDescription )")
                print("Device : \(result.deviceData ?? "")")
                self.postNonceToServer(paymentMethodNonce: result.paymentMethod?.nonce ?? "" )
                
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func postNonceToServer(paymentMethodNonce: String) {
        // Update URL with your server
        let paymentURL = URL(string: "https://your-server.example.com/payment-methods")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
        }.resume()
    }
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
    
    func fetchClientToken() {
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: String.Encoding.utf8)

            // As an example, you may wish to present Drop-in at this point.
            // Continue to the next section to learn more...
            }.resume()
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
           //payPalDriver.viewControllerPresentingDelegate = self
           //payPalDriver.appSwitchDelegate = self
        // Optional
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalCheckoutRequest(amount: "2.32")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.tokenizePayPalAccount(with: request){ tokenizedPayPalAccount, error in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                // post order
                DispatchQueue.main.async {
                    self.setupDictionary()
                }
                // Access additional information
//                let email = tokenizedPayPalAccount.email
//                let firstName = tokenizedPayPalAccount.firstName
//                let lastName = tokenizedPayPalAccount.lastName
//                let phone = tokenizedPayPalAccount.phone
                
                // See BTPostalAddress.h for details
//                let billingAddress = tokenizedPayPalAccount.billingAddress
//                let shippingAddress = tokenizedPayPalAccount.shippingAddress
            } else if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                // Buyer canceled payment approval
            }
        }
    }
    func postOrder(orderDictionary: [String: Any]){
        let orderVM = OrderViewModel()
        orderVM.postOrder(orderDictionary:  orderDictionary) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    print ("post order Error \n \(error?.localizedDescription ?? "")" )
                }
                return
            }
            
        guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
                DispatchQueue.main.async {
                    print ("post order Response \n \(response ?? HTTPURLResponse())" )

                }
                return
            }
            DispatchQueue.main.async {
                
            let snackbar = TTGSnackbar(message: "order was added successfully!", duration: .middle)
            snackbar.tintColor =  UIColor(named: "Green")
            snackbar.show()
                print ("post order Response \n \(response ?? HTTPURLResponse())" )
                print("order was added successfully")
                print("Done")
            }
        }
    }
    func setupDictionary(){
        let order : [String : Any] = [
        "order" : [
                       "confirmed" : true ,
                       "contact_email" : "@juhygt",
                       "currency": "USD",
                       "created_at" : "20-2-2015",
                       "number" : 2 ,
                       "order_number" : 123 ,
                       "order_status_url" : "",
                       "current_subtotal_price": "15.0",
                       "current_total_discounts": "0.2",
                       "current_total_price": "15.0",
                       "line_items" : [[
                        "fulfillable_quantity" : 5,
                        "name":"Egypt",
                        "price":"0.10",
                        "quantity" : 3,
                        "sku" : "okijuhygtrf",
                        "title" : "Shooes"
                       ]]
                   ]
               ]
        
        
        
        
        /*[ "line_items" : [
            [
              "title": "Big Brown Bear Boots",
              "price": 74.99,
              "grams": "1300",
              "quantity": 3,
              "tax_lines": [
                [
                  "price": 13.5,
                  "rate": 0.06,
                  "title": "State tax"
                ]
              ]
            ]
        ],
        "transactions" : [
            [
              "kind": "sale",
              "status": "success",
              "amount": 238.47
            ]
          ]
                                       ]*/
    postOrder(orderDictionary: order)
                                       }
}


