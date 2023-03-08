//
//  ShoppingCartViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    @IBOutlet weak var cartTable: UITableView!
    private var cartArray: [LineItem]?
    var lineItem = LineItem()
    private var counter: Int8 = 0
    private var shoppingCartVM = ShoppingCartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        lineItem.price = "231 $"
        lineItem.title = "gray t-shirt"
        lineItem.quantity = 3
        lineItem.image = "ct4"
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
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CartViewController
        vc.cartArray = self.cartArray
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
        cell.itemPrice.text = cartArray?[indexPath.row].price
        //cell.itemQuntity.text = "Qty: \( cartArray?[indexPath.row].quantity?.formatted() ?? "0")"
        cell.cartImage.image = UIImage(named: cartArray?[indexPath.row].image ?? "ct4")
        cell.counterProtocol = self
        return cell
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
    func increaseCounter() -> Int8 {
        counter = counter + 1
        print(counter)
        return counter
    }
    
    func decreaseCounter() -> Int8{
        if counter <= 0 {
            self.showAlert(msg: "do you want to delete this item")
        }
        else {
            counter = counter - 1
        }
        return counter
    }
}

extension ShoppingCartViewController {
    func getData(){
        shoppingCartVM.getShoppingCart(userId: 132)
        shoppingCartVM.bindingCart = {
            self.cartArray = self.shoppingCartVM.cartList
            DispatchQueue.main.async {
                self.cartTable.reloadData()
            }
        }
    }
}
