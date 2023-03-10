//
//  image.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 26/02/2023.
//

import Foundation
class image: Decodable{
    var src: String?
   
}

class Image: Decodable{
    var src: String?
    init(src: String? = nil) {
        self.src = src
    }
}
