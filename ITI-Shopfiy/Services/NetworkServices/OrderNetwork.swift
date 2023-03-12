//
//  OrderNetwork.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 08/03/2023.
//

import Foundation
class OrderNetwork {
    static let sharedinstance = OrderNetwork()
    private init(){}
    func post(userOrder: [String: Any], url: String, completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userOrder, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }.resume()
    }
    func putCustomer(customer: Customer , completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
        guard let url = URL(string: URLService.updateCustomer(userID: UserDefaultsManager.sharedInstance.getUserID() ?? 0)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: customer.asDictionary(), options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }.resume()
    }
    
    func putCustomer(customer: NewCustomer , completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
            guard let url = URL(string: URLService.updateCustomer(userID: UserDefaultsManager.sharedInstance.getUserID() ?? 0)) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let session = URLSession.shared
            request.httpShouldHandleCookies = false
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: customer.asDictionary(), options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            session.dataTask(with: request) { (data, response, error) in
                completionHandler(data, response, error)
            }.resume()
        }
}
