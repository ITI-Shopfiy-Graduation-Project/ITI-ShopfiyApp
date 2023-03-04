//
//  AddressHistoryTableViewCell.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import UIKit

class AddressHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var street: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
