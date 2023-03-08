//
//  ShoppingCartViewModel.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import Foundation
class ShoppingCartViewModel {
    var bindingCart : (()->()) = {}
    var cartList :[LineItem]?{
        didSet{
            bindingCart()
        }
    }
    
    func getShoppingCart(userId: Int) {
        CartNetwork.sharedInstance.fetchUserCart(userEmail: "dsax") { result in
            if let result = result {
                self.cartList = result.draft_order?.line_items
            }
        }
       /* AddressNetwork.sharedInstance.fetchAllUserAddresses(userId: userId) { result in
            if let result = result {
                self.addressList = result.addresses
            }
        }*/
    }
}
