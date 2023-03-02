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
    private var cartArray: [LineItem]?
    private var counter: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableConfiguration()
        var lineItem = LineItem()
        lineItem.price = "231 $"
        lineItem.title = "gray t-shirt"
        lineItem.quantity = 3
        lineItem.image = "ct4"
        cartArray = [lineItem , lineItem , lineItem]
        // Do any additional setup after loading the view.
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
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
        cell.itemQuntity.text = "Qty: \( cartArray?[indexPath.row].quantity?.formatted() ?? "0")"
        cell.cartImage.image = UIImage(named: cartArray?[indexPath.row].image ?? "ct4")
            
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension CartViewController : counterProtocol {
    func increaseCounter() {
        counter = counter + 1
    }
    
    func decreaseCounter() {
        if counter <= 0 {
            showAlert(msg: "njbhvgfc")
        }
        else {
            counter = counter - 1
        }
    }
}
