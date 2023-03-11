//
//  ShoppingCartViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import UIKit
import Reachability
import TTGSnackbar
class ShoppingCartViewController: UIViewController {
    private var flag: Bool = true
    @IBOutlet weak var cartTable: UITableView!
    private var deletedLineItem : LineItem?
    private var cartArray: [LineItem]?
    var lineItem = LineItem()
    private var counter: Int8 = 1
    private var shoppingCartVM = ShoppingCartViewModel()
    private var subTotalPrice = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        lineItem.price = "231 $"
        lineItem.title = "gray t-shirt"
        lineItem.quantity = 3
        lineItem.sku = "ct4"
        cartArray = [lineItem , lineItem , lineItem]
        tableConfiguration()
        getData()
        
    }
    func tableConfiguration(){
        cartTable.delegate = self
        cartTable.dataSource = self
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTable.register(nib, forCellReuseIdentifier: "cell")
    }
    @IBAction func processedToCheckout(_ sender: Any) {
   /*     let signUpVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    */}
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPromoCode" {
            let vc = segue.destination as! CartViewController
            vc.cartArray = self.cartArray
            vc.subTotal = self.subTotalPrice
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
            cell.itemPrice.text = price.formatted()
        }
        else
        {
            cell.itemPrice.text = cartArray?[indexPath.row].price
        }
        cell.quantityCount.text = cartArray?[indexPath.row].quantity?.formatted()
        //cell.itemQuntity.text = "Qty: \( cartArray?[indexPath.row].quantity?.formatted() ?? "0")"
        let image = URL(string: cartArray?[indexPath.row].sku ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.cartImage.kf.setImage(with:image)
        cell.counterProtocol = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if !Reachability.forInternetConnection().isReachable(){
                
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
    func showAlert() {
        self.showAlert(msg: "do u want delete")
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
            self.cartArray?.removeAll()
            self.cartArray = self.shoppingCartVM.cartList
            self.shoppingCartVM.cartList?.forEach({ item in
                self.subTotalPrice += Double(item.price ?? "0") ?? 0.0
            })
            self.cartTable.reloadData()
            print("sub total : \(self.subTotalPrice)")
        }
    }
}

extension ShoppingCartViewController {
    func deleteLineItemProduct(indexPath : IndexPath)
    {
        deletedLineItem = cartArray?[indexPath.row]
        cartArray?.remove(at: indexPath.row)
        cartTable.deleteRows(at: [indexPath], with: .automatic)
        showSnackBar(index: indexPath.row)
        DispatchQueue.main.asyncAfter(deadline: .now()+5){
            if self.flag == true {
                if !(self.cartArray?.count == 0){
                    self.putDraftOrder(lineItems: self.cartArray ?? [])
                }
                else
                {
                    // delete draft order
                }
            }
        }
    }
    
    func showSnackBar(index : Int){
        let snackbar = TTGSnackbar(
            message: "Item \(String(describing: deletedLineItem?.title)) was unsaved successfully",
            duration: .long,
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
        snackbar.messageTextColor = UIColor.black
        snackbar.show()
    }
    
    private func undoDeleting(index: Int){
        if let lineItem = deletedLineItem {
            cartArray?.insert(lineItem, at: index)
            cartTable.reloadData()
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
            
            print("lineItem was added successfully")
            
            
        }
        
    }
}

