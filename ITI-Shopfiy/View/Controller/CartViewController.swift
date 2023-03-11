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
    private var shoppingCartVM = ShoppingCartViewModel()
    var discount : [Discount] = []
    let discountModel = DiscountViewModel()
    var subTotal : Double?
    var discountPrice : Double = 0.0
    var totalPriceValue : Double = 0.0
    var cartArray: [LineItem]?
    private var counter: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableConfiguration()
        codeError.text = ""
       /* let lineItem = LineItem()
        lineItem.price = "231 $"
        lineItem.title = "gray t-shirt"
        lineItem.quantity = 3
        lineItem.image = "ct4"
        cartArray = [lineItem , lineItem , lineItem]*/
        // Do any additional setup after loading the view.
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
        getPromoCode()
        totalPriceValue = discountPrice
        //getData()
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    func tableConfiguration(){
        CartTable.delegate = self
        CartTable.dataSource = self
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        CartTable.register(nib, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func applyPromoCode(_ sender: Any) {
        validatePromoCode()
    }
    
    @IBAction func proceedToCheckout(_ sender: Any) {
    }
}

extension CartViewController: UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Shopping Cart"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
        cell.itemName.text = cartArray?[indexPath.row].title
        cell.itemPrice.text = cartArray?[indexPath.row].price
       // cell.itemQuntity.text = "Qty: \( cartArray?[indexPath.row].quantity?.formatted() ?? "0")"
        let image = URL(string: cartArray?[indexPath.row].sku ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.cartImage.kf.setImage(with:image)
        cell.quantityCount.isHidden = true
        cell.decreseItem.isHidden = true
        cell.increaseItem.isHidden = true
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension CartViewController {

}

extension CartViewController {
    func validatePromoCode(){
        if promoCodeET.text != "" {
            if promoCodeET.text == discount.first?.code ?? ""
            {
                //change it with user second name
                promoCodeET.text = UserDefaultsManager.sharedInstance.getUserName()
                if promoCodeET.text != nil
                {
                    codeError.text = "Valid"
                    codeError.textColor = UIColor(named: "Green")
                    self.discountPrice = 0.7 * (self.subTotal ?? 0.0)
                    totalPriceValue = (subTotal ?? 0.0) - discountPrice
                    promoCodeValue.text = self.discountPrice.formatted()
                }
                else
                {
                    self.setInvalidDiscount(msg: "Used Promo code")
                }
            }
            else{
                self.setInvalidDiscount(msg :"Not valid")
                
            }
        }
        else
        {
            self.setInvalidDiscount(msg : "Enter promo code")
        }
    }
    
    func getPromoCode() {
        discountModel.discountUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com//admin/api/2023-01/price_rules/1377368047897/discount_codes.json"
        discountModel.getDiscount()
        discountModel.bindingDiscount =
        {() in
            self.renderDiscount()
        }
    }
    
    func renderDiscount () {
        DispatchQueue.main.async {
            self.discount = self.discountModel.discoutsResults ?? []
        }
    }
    
    private func setInvalidDiscount(msg : String){
        codeError.text = msg
        codeError.textColor = UIColor(named: "Red")
        self.discountPrice = 0.0
        totalPriceValue = subTotal ?? 0.0
        promoCodeValue.text = "0"
    }
}
