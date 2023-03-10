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
    var variants : [variants]?
    var image: Image?
    var images: [Image]?
    var state: Bool? = false

    init(id: Int? = nil, title: String? = nil, vendor: String? = nil, body_html: String? = nil, product_type: String? = nil, created_at: String? = nil, variants: [variants]? = nil, image: Image? = nil, images: [Image]? = nil, state: Bool? = nil) {
        self.id = id
        self.title = title
        self.vendor = vendor
        self.body_html = body_html
        self.product_type = product_type
        self.created_at = created_at
        self.variants = variants
        self.image = image
        self.images = images
        self.state = state
    }
   
    
}

struct Review{
    var image: String?
    var rating: Double?
    var review: String?
    var user: String?
}
