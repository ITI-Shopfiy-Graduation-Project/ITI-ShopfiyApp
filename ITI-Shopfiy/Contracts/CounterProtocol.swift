//
//  CounterProtocol.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 02/03/2023.
//

import Foundation
protocol CounterProtocol {
    func showNIPAlert(msg: String)
    func deleteItem(indexPath : IndexPath)
    
    func increaseCounter() 
    func decreaseCounter(price: String)
    func setItemQuantityToPut(quantity: Int , index: Int)
    
}
