//
//  File.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 27/02/2023.
//

import Foundation
class BrandViewModel{
    var BrandssUrl : String?
    var bindingBrands : (()->()) = {}
    
    var brandsResults :[Brands]?{
        didSet{
            bindingBrands()
        }
    }
}
extension BrandViewModel:getBrandsProtocol
{
   
    
    func getBrands() {
        BrandsNetwork.brandsfetchData(url:BrandssUrl, handlerComplition: { result in
            self.brandsResults =  result?.smart_collections
            
        })
    
    }
    
    
    
    
}
