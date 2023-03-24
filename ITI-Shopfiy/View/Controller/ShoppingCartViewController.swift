//
//  ShoppingCartViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import UIKit
import TTGSnackbar
import Reachability
class ShoppingCartViewController: UIViewController {
    private var flag: Bool = true
    @IBOutlet weak var subTotal_lable: UILabel!
    @IBOutlet weak var cartTable: UITableView!
    private var deletedLineItem : LineItem?
    private var cartArray: [LineItem]?
    var lineItem = LineItem()
    private var counter: Int8 = 1
    private var shoppingCartVM = ShoppingCartViewModel()
    private static var subTotalPrice = 0.0
    private let indicator = UIActivityIndicatorView(style: .large)

    @IBOutlet weak var processed_btn: UIButton!
    
    
    override func viewDidLoad() {
        self.navigationController!.navigationBar.tintColor = UIColor(named: "Green") ?? .green
        super.viewDidLoad()
        cartArray = nil
        ShoppingCartViewController.subTotalPrice = 0.0
        tableConfiguration()
    //    subTotal_lable.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    func tableConfiguration(){
        cartTable.delegate = self
        cartTable.dataSource = self
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTable.register(nib, forCellReuseIdentifier: "cell")
    }
    @IBAction func processedToCheckout(_ sender: Any) {
 }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if Reachability.forInternetConnection().isReachable(){
            
            if segue.identifier == "toPromoCode" {
                let vc = segue.destination as! CartViewController
                vc.cartArray = self.cartArray
                vc.subTotal = ShoppingCartViewController.subTotalPrice
            }
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }
    
    
    @IBAction func saveChanges(_ sender: Any) {
        guard let cart = cartArray else {return}
        if Reachability.forInternetConnection().isReachable(){
            putDraftOrder(lineItems: cart)
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
        
    }
    
    
    
}
extension ShoppingCartViewController: UITableViewDataSource {
    
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
        if UserDefaultsManager.sharedInstance.getCurrency() == "EGP" {
            let price = (Double(cartArray?[indexPath.row].price ?? "0") ?? 0.0)  * 30
            let priceString = "\(price.formatted()) EGP"
            cell.itemPrice.text = priceString
        }
        else
        {
            let priceString = "\(cartArray?[indexPath.row].price ?? "0") $"
            cell.itemPrice.text = priceString
        }
        cell.quantityCount.text = cartArray?[indexPath.row].quantity?.formatted()
        //cell.itemQuntity.text = "Qty: \( cartArray?[indexPath.row].quantity?.formatted() ?? "0")"
        let image = URL(string: cartArray?[indexPath.row].sku ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.cartImage.kf.setImage(with:image)
        cell.counterProtocol = self
        cell.indexPath = indexPath
        cell.lineItem = cartArray
        cell.disableDecreaseBtn()
        self.setSubTotal()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if !Reachability.forInternetConnection().isReachable(){
                self.showAlert(msg: "Please check your internet connection")
            }
            else{
                deleteLineItemProduct(indexPath: indexPath)
            }
        }
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("me2mo")
        let vc = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        vc.product_ID = cartArray?[indexPath.row].product_id
        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView : UIView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
}

extension ShoppingCartViewController: CounterProtocol {
    func setItemQuantityToPut(quantity: Int, index: Int) {
        self.cartArray?[index].quantity = quantity
    }
    
    func increaseCounter() {
        Self.subTotalPrice = 0.0
        for index in  0...(cartArray?.count ?? 0) - 1
        {
            let itemPrice = (Double(cartArray?[index].price ?? "") ?? 0.0) * (Double (cartArray?[index].quantity ?? 0))
            ShoppingCartViewController.subTotalPrice = Self.subTotalPrice + itemPrice
        }
        print("subtotal :\(Self.subTotalPrice)")
        setSubTotal()
    }
    
    func decreaseCounter(price: String) {
        
        
        let itemPrice = Double(price) ?? 0.0
            Self.subTotalPrice = Self.subTotalPrice - itemPrice
        
        print("subtotal :\(Self.subTotalPrice)")
        setSubTotal()
    }
    
    func deleteItem(indexPath: IndexPath) {
        self.deleteLineItemProduct(indexPath: indexPath)
        setSubTotal()
    }
    
    func showNIPAlert(msg: String) {
        self.showAlert(msg: msg)
    }
}

extension ShoppingCartViewController {
    func getData(){
        shoppingCartVM.getShoppingCart()
        shoppingCartVM.bindingCart = {
            self.renderView()
            
        }
    }
    func renderView(){
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.cartArray?.removeAll()
            self.cartArray = self.shoppingCartVM.cartList
            self.configureView()
            print("sub total : \(Self.subTotalPrice)")
            if self.cartArray?.count == 0 {
            self.cartTable.isHidden = true
            }
            else {
                self.cartTable.isHidden = false
                self.processed_btn.isHidden = false
            }
            
            }
   
    }

    func configureView(){
        if cartArray != nil {
            self.shoppingCartVM.cartList?.forEach({ item in
                Self.subTotalPrice += Double(item.price ?? "0") ?? 0.0
            })
            self.cartTable.reloadData()
            setSubTotal()
            UserDefaultsManager.sharedInstance.setCartState(cartState: true)
        }
        else {        }
    }
}

extension ShoppingCartViewController {
    func deleteLineItemProduct(indexPath : IndexPath)
    {
        if Reachability.forInternetConnection().isReachable(){
            deletedLineItem = cartArray?[indexPath.row]
            cartArray?.remove(at: indexPath.row)
            cartTable.deleteRows(at: [indexPath], with: .automatic)
            showSnackBar(index: indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: .now()+3.5){
                if self.flag == true {
                    if !(self.cartArray?.count == 0){
                        self.putDraftOrder(lineItems: self.cartArray ?? [])
                    }
                    else
                    {
                        self.deleteCart()
                    }
                }
            }
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }
    
    func showSnackBar(index : Int){
        let snackbar = TTGSnackbar(
            message: "Item \(String(describing: deletedLineItem?.title)) was unsaved successfully",
            duration: .middle,
            actionText: "Undo",
            actionBlock: { (snackbar) in
                print("snack bar Click action!")
                self.flag = false
                if self.flag == false{
                    self.undoDeleting(index: index)
                }
            }
        )
        snackbar.actionTextColor = .red
        //snackbar.borderColor = .clear
        snackbar.backgroundColor = .black
        snackbar.messageTextColor = .white
        snackbar.show()
    }
    
    private func undoDeleting(index: Int){
        if let lineItem = deletedLineItem {
            cartArray?.insert(lineItem, at: index)
            cartTable.reloadData()
            self.increaseCounter()
        }
    }
    
    func putDraftOrder(lineItems : [LineItem]){
        var draftOrder = DrafOrder()
        draftOrder.email = UserDefaultsManager.sharedInstance.getUserEmail()
        draftOrder.line_items = lineItems
        var shoppingCart = ShoppingCartPut()
        shoppingCart.draft_order = draftOrder
        shoppingCartVM.putNewCart(userCart: shoppingCart) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    print ("delete cart Error \n \(error?.localizedDescription ?? "")" )
                }
                return
            }
            
            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
                DispatchQueue.main.async {
                    print ("delete cart Response \n \(response ?? HTTPURLResponse())" )
                }
                return
            }
            self.increaseCounter()
            print("lineItem was added successfully")
        }
    }
    func deleteCart(){
        shoppingCartVM.deleteCart { error in
            if error != nil {
                UserDefaultsManager.sharedInstance.setUserCart(cartId: nil)
                UserDefaultsManager.sharedInstance.setCartState(cartState:false)
                self.increaseCounter()
                self.subTotal_lable.text = "0"
                
            }
            else
            {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

extension ShoppingCartViewController {
    func setSubTotal(){
        if UserDefaultsManager.sharedInstance.getCurrency() == "EGP" {
            let price = (Double(Self.subTotalPrice) )  * 30
            let priceString = "\(price.formatted()) EGP"
            subTotal_lable.text = priceString
        }
        else
        {
            let price = (Double(Self.subTotalPrice) )
            let priceString = "\(price.formatted()) $"
            DispatchQueue.main.async {
                self.subTotal_lable.text = priceString
            }
        }
    }
}
