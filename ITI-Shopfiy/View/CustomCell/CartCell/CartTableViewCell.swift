//
//  CartTableViewCell.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 21/02/2023.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var delete_Btn: UIButton!
    var counter = 1
    @IBOutlet weak var increaseItem: UIButton!
    @IBOutlet weak var decreseItem: UIButton!
    var counterProtocol: CounterProtocol?
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var quantityCount: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    var indexPath: IndexPath!
    var lineItem : [LineItem]!
    override func awakeFromNib() {
        super.awakeFromNib()
        counterProtocol = CounterProtocol.self as? CounterProtocol
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        counterProtocol?.deleteItem(indexPath: indexPath)
    }
    @IBAction func increaseBtn(_ sender: UIButton) {
        if counter < ((lineItem[indexPath.row].grams ?? 1) - 2) {
            counter = counter + 1
            quantityCount.text = String (counter)
            lineItem[indexPath.row].quantity = counter
            counterProtocol?.increaseCounter()
            counterProtocol?.setItemQuantityToPut(quantity: counter, index: indexPath.row)
        }
         else
        {
             counterProtocol?.showNIPAlert(msg: "sorry you have reached the inventory quantity limit" )
        }
}
    @IBAction func dcreaseBtn(_ sender: UIButton) {
        if counter > 1 {//Renlace the static with lineItem?.arams num +
            counter = counter - 1
            lineItem[indexPath.row].quantity = counter
            quantityCount.text = String (counter)
            counterProtocol?.decreaseCounter()
            counterProtocol?.setItemQuantityToPut(quantity: counter, index: indexPath.row)
        }
         else
        {
             counterProtocol?.showNIPAlert(msg: "do you want to delete this item?" )
        }
    }
}
