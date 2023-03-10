//
//  PaymentViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.

//paypal token sandbox_mf932tgj_bmwnvznx5nj7n6dg
//"sandbox_jyvqscf2_jpbyz2k4fnvh6fvt"


import UIKit
import PassKit
import Braintree
import BraintreeDropIn
import TTGSnackbar
class PaymentViewController: UIViewController {
    @IBOutlet weak var payPal: UIButton!
    @IBOutlet weak var cashOnDelivery: UIButton!
    @IBOutlet weak var addressDescription: UITextView!
    @IBOutlet weak var defaultAddress: UILabel!
    @IBOutlet weak var cash_btn: UIButton!
    @IBOutlet weak var paypal_btn: UIButton!
    @IBOutlet weak var apple_btn: UIButton!
    @IBOutlet weak var paymentView: UIStackView!
    var addressFlag: Bool = false
    var braintreeClient: BTAPIClient!
    var totalPrice: Double = 0
    var userTotalCost: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserAddress()
        setPaymentMethodAccability()
        setDefaultButtonTheme()
        
        braintreeClient = BTAPIClient(authorization: "sandbox_q7ftqr99_7h4b4rgjq3fptm87")!
    }
    
    @IBAction func GooglePay(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.setDefaultButtonTheme()
            sender.setTitleColor(UIColor(named: "Green"), for: .selected)
            sender.alpha = 1
            sender.self.backgroundColor = .black
            sender.backgroundColor = UIColor(ciColor: .gray)
            sender.borderColor = UIColor(named: "Green")
            sender.borderWidth = 1.5
            sender.cornerRadius = 10
            self.setupPayPal()
        }
    }
    @IBAction func cashOnDelivery(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.setDefaultButtonTheme()
            sender.titleLabel?.textColor = UIColor(named: "Green")
            sender.alpha = 1
            sender.backgroundColor = UIColor(ciColor: .gray)
            sender.setTitleColor(UIColor(named: "Green"), for: .selected)
            sender.borderColor = UIColor(named: "Green")
            sender.borderWidth = 1.5
            sender.cornerRadius = 10
        }
    }
    func setUserAddress(){
        let address = UserDefaultsManager.sharedInstance.getUserAddress()
        if address != "" {
            self.defaultAddress.text = address
            self.addressFlag = true
        }
        else{
            self.defaultAddress.text = "Choose Address"
            self.addressDescription.text = "choose address for payment transactions"
            self.addressFlag = false
        }
    }
    
    func setPaymentMethodAccability(){
        if addressFlag == true {
            paymentView.isUserInteractionEnabled = true
            paymentView.alpha = 1
           paymentView.backgroundColor = UIColor(named: "White")
        }
        else{
             paymentView.isUserInteractionEnabled = false
             paymentView.alpha = 0.3
             paymentView.backgroundColor = UIColor.gray
        }
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
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalCheckoutRequest(amount: totalPrice.formatted())
        request.currencyCode = UserDefaultsManager.sharedInstance.getCurrency()
        
        payPalDriver.tokenizePayPalAccount(with: request){ tokenizedPayPalAccount, error in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                // post order
                DispatchQueue.main.async {
                    self.setupDictionary()
                }
                
                //userTotalCost = Double(tokenizedPayPalAccount.creditFinancing?.totalCost.)
          //      if tokenizedPayPalAccount.creditFinancing?.totalCost >= totalPrice 
                    self.setupDictionary()
                    
                
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
    func setDefaultButtonTheme(){
        cashOnDelivery.alpha = 1
        cashOnDelivery.backgroundColor = UIColor(named: "FourthGray")
        cashOnDelivery.borderColor = .black
        cashOnDelivery.borderWidth = 1
        cashOnDelivery.titleLabel?.textColor = .black
        payPal.titleLabel?.textColor = .black
        payPal.borderColor = .black
        payPal.alpha = 1
        payPal.backgroundColor = UIColor(named: "FourthGray")
        payPal.borderWidth = 1
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
                orderVM.updateUserWithCoupon(coupon: "btgvfcd")
                print ("post order Response \n \(response ?? HTTPURLResponse())" )
                print("order was added successfully")
                print("Done")
            }
        }
    }
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, dd, YYYY - hh:mm a"
        let result = dateFormatter.string(from: date)
        return result
    }
    func setupDictionary(){
        let order : [String : Any] = [
            "order" : [
                "confirmed" : true ,
                "contact_email" : UserDefaultsManager.sharedInstance.getUserEmail() ?? "",
                "currency": "USD",
                "created_at" : getCurrentDate() ,
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
        postOrder(orderDictionary: order)
    }
}
