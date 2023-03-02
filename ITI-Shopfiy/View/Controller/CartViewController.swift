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
   // private var cartArray: Cart
    override func viewDidLoad() {
        super.viewDidLoad()
        tableConfiguration()
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
       // return cartArray.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
        
            
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
   
}

