//
//  CartTableViewCell.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 21/02/2023.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    var counter = 1
    @IBOutlet weak var increaseItem: UIButton!
    @IBOutlet weak var decreseItem: UIButton!
    var counterProtocol: CounterProtocol?
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var quantityCount: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        counterProtocol = CounterProtocol.self as? CounterProtocol
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func increaseBtn(_ sender: UIButton) {
        counter = counter + 1
        quantityCount.text = counter.formatted()
        
        //counterProtocol?.increaseCounter().formatted()
        
        
    }
    @IBAction func dcreaseBtn(_ sender: UIButton) {
        if counter > 1 {
            counter = counter - 1
            quantityCount.text = counter.formatted()
        }
        else {
            counterProtocol?.showAlert()
        }
    }
}
