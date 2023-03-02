//
//  Products.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 26/02/2023.
//

import Foundation
class Products : Decodable{
    var id : Int?
    var title : String?
    var vendor : String?
    var body_html: String?
    var product_type: String?
    var created_at: String?
    var user_id: Int?
    var variants : [variants]?
    var image : image?
    var images: [Image]?
}
