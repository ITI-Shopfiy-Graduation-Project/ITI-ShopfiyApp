//
//  OrdersViewController.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 25/02/2023.
//

import UIKit

class OrdersViewController: UIViewController {
    var orderr : [OrderInfo] = []

    @IBOutlet weak var OrdersTblView: UITableView!
    override func viewDidLoad() {
        self.navigationController!.navigationBar.tintColor = UIColor(named: "Green") ?? .green
        super.viewDidLoad()
        OrdersTblView.dataSource = self
        OrdersTblView.delegate = self
       
    }
    

 

}
extension OrdersViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for:indexPath) as!OrdersTableViewCell
        cell.userEmail.text = orderr[indexPath.row].email!
        cell.price.text = (orderr[indexPath.row].current_total_price)! + " " + (orderr[indexPath.row].currency)!
        cell.createdTime.text = orderr[indexPath.row].created_at
        cell.number.text =  String((orderr[indexPath.row].id)!)

        return cell
 
    }
}
extension OrdersViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0;
    }
    
    
    
    
}
