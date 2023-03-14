//
//  PaymentViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.

// sb-lfkrq25233161@personal.example.com
// personal123


import UIKit
import PassKit
import Braintree
import BraintreeDropIn
import TTGSnackbar
import Reachability

class PaymentViewController: UIViewController, AddressDelegate {
    func getAddressInfo(Address: Address) {
        userAddress = Address
       // setUserAddress()
       // setPaymentMethodAccability()
        print(userAddress)
    }
    
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
    static var totalPrice: Double = 0
    var userTotalCost: Double = 0.0
    private var userAddress : Address?
    
    var reachability:Reachability!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachability = Reachability.forInternetConnection()

        setDefaultButtonTheme()
        // aletrnative token sandbox_fwf8wnc6_7h4b4rgjq3fptm87  || "sandbox_jyvqscf2_jpbyz2k4fnvh6fvt"
        braintreeClient = BTAPIClient(authorization: "sandbox_q7ftqr99_7h4b4rgjq3fptm87")!
    }
    override func viewWillAppear(_ animated: Bool) {
        setUserAddress()
        setPaymentMethodAccability()

    }
    @IBAction func chooseAddress(_ sender: Any) {
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            let vc = UIStoryboard(name: "AddressDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "address") as! AddressViewController
            vc.addressDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func GooglePay(_ sender: UIButton) {
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            
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
    }
    
    @IBAction func cashOnDelivery(_ sender: UIButton) {
        if !reachability.isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
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
            self.showAlertForCashPayment(msg: "Do you want to complete your payment transaction")
        }
    }
    
    func setUserAddress(){
        let address = UserDefaultsManager.sharedInstance.getUserAddress()
        if userAddress != nil {
            self.defaultAddress.text = userAddress?.address1
            self.addressDescription.text = "\(String(userAddress?.city ?? "city")), \(String(describing: userAddress?.country ?? "country"))"
            self.addressFlag = true

        }
        else if address != "" && address != nil {
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
       /* let request:BTPayPalCheckoutRequest?
        // Specify the transaction amount here. "2.32" is used in this example.
        if UserDefaultsManager.sharedInstance.getCurrency() == "EGP" {
            let price = totalPrice  * 30
            request = BTPayPalCheckoutRequest(amount: "1532")
            request?.currencyCode = "EGP"
        }
    else
        {
        request = BTPayPalCheckoutRequest(amount: totalPrice.formatted())
        request?.currencyCode = "USD"
    }*/
        print("total price : \(Self.totalPrice)")
        let request = BTPayPalCheckoutRequest(amount: "8465")
        request.currencyCode = "USD"
        payPalDriver.tokenizePayPalAccount(with: request){ tokenizedPayPalAccount, error in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                // post order
                DispatchQueue.main.async {
                    self.setupDictionary()
                }
                
                //userTotalCost = Double(tokenizedPayPalAccount.creditFinancing?.totalCost.)
          //      if tokenizedPayPalAccount.creditFinancing?.totalCost >= totalPrice
                    
                
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
                let cartVM = ShoppingCartViewModel()
                cartVM.deleteCart { error in
                    if error != nil {
                        UserDefaultsManager.sharedInstance.setUserCart(cartId: nil)
                        UserDefaultsManager.sharedInstance.setCartState(cartState: false)

                    }
                    else
                    {
                        print(error?.localizedDescription ?? "")
                    }
                }
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
                "currency": UserDefaultsManager.sharedInstance.getCurrency(),
                "created_at" : getCurrentDate() ,
                "number" : 2 ,
                "order_number" : 123 ,
                "order_status_url" : UserDefaultsManager.sharedInstance.getUserEmail() ?? "@email.com",
                "current_subtotal_price": defaultAddress.text ?? "cairo",
                "current_total_discounts": "01091190679",
                "current_total_price": PaymentViewController.totalPrice.formatted(),
                "line_items" : [[
                    "fulfillable_quantity" : 5,
                    "name":"Egypt",
                    "price":"0.10",
                    "quantity" : 3,
                    "sku" : "okijuhygtrf",
                    "title" : "T-shirt"
                ]],
                "customer": [
                    "id":UserDefaultsManager.sharedInstance.getUserID()
                        ]
            ]
        ]
        postOrder(orderDictionary: order)
    }
}

extension PaymentViewController {
    func showAlertForCashPayment(msg: String)
    {
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "close", style: .cancel))
                        
            alert.addAction(UIAlertAction(title: "Pay Now", style: .default , handler: { action in
                self.setupDictionary()
            }))
            self.present(alert, animated: true, completion: nil)
    }
}
