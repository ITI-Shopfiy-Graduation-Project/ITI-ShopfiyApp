//
//  CartTableViewCell.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 21/02/2023.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var quantityCount: UILabel!
    @IBOutlet weak var itemQuntity: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
