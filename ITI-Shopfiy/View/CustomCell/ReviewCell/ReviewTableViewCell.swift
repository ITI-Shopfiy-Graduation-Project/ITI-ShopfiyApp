//
//  ReviewTableViewCell.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 09/03/2023.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userRating: CosmosView!
    @IBOutlet weak var userReview: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = userImage.frame.height / 2
    }

    func configureCell(user: Review) {
        userImage.image = UIImage(named: user.image ?? "zizo")
        userRating.rating = user.rating ?? 3
        userReview.text = user.review
        userName.text = user.user
        
    }
    
    
}
