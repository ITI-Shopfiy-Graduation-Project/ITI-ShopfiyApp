//
//  OrdersViewController.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 25/02/2023.
//

import UIKit

class OrdersViewController: UIViewController {
    var orderModel:GetOrderVM?
    var ordr :[OrderInfo] = []
    var ordrappend : OrderInfo?
    var cartcount = Order()
    var ordar = Order()
    var addtoLine : OrderInfo?
    var arr : [OrderInfo] = []
    var orderr : [OrderInfo] = []
    let indicator = UIActivityIndicatorView(style: .large)

    @IBOutlet weak var OrdersTblView: UITableView!
    override func viewDidLoad() {
        orderModel = GetOrderVM()
        orderModel?.getOrdersUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/orders.json?status=any"
        self.navigationController!.navigationBar.tintColor = UIColor(named: "Green") ?? .green
        super.viewDidLoad()
        OrdersTblView.dataSource = self
        OrdersTblView.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        orderModel?.getOrder()
        orderModel?.bindingOrder = {()in
            self.renderOrders()
            
        }
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        orderr.removeAll()
    }

 

}
extension OrdersViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for:indexPath) as!OrdersTableViewCell
        _ = ordr
        cell.userEmail.text = ordar.orders?[indexPath.row].email
        cell.price.text = "estimited Delivery in 2 days"
        cell.createdTime.text = ordar.orders?[indexPath.row].created_at

        cell.number.text =  String((ordar.orders?[indexPath.row].id)!)
         
        return cell
 
    }
}
extension OrdersViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0;
    }
    
    
    
    
}

extension OrdersViewController {
    func renderOrders() {
        DispatchQueue.main.async {
           
            self.cartcount = (self.orderModel?.OrderResult) ?? Order()
            self.cartcount.orders?.forEach({ emaill in
                self.ordar = self.cartcount
                if  emaill.email ==  UserDefaultsManager.sharedInstance.getUserEmail()!
                {  self.addtoLine = emaill
                    self.ordr.append(emaill)
                    self.OrdersTblView.reloadData()
                }
                self.indicator.stopAnimating()
                
            })
           
//            self.product = self.CategoryModel?.productsResults ?? []
          
        }
//        print (self.ordr[0].contact_email)
    }
    
    
    
    
}
