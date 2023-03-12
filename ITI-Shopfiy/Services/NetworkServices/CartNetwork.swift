//
//  CartNetwork.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 04/03/2023.
//

import Foundation
import Alamofire

class CartNetwork {
    static var sharedInstance = CartNetwork()
    private init(){}
    
    func fetchUserCart (handlerComplition : @escaping (DraftOrderResponse?)->Void) {
        let draftOrderID = UserDefaultsManager.sharedInstance.getUserCart() ?? 0 //1110994288921 1111094493465
        print(draftOrderID)
       let requestURL: NSURL = NSURL(string: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/draft_orders/\(draftOrderID).json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            if let data = data {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200 && statusCode < 300) {
                    print("Everyone is fine, file downloaded successfully.")
                    do{
                        let json = try JSONDecoder().decode(DraftOrderResponse.self , from: data) as? DraftOrderResponse
                        
                        //print(json)
                         handlerComplition(json)
                    }
                    catch{ print("erroMsg") }
                    handlerComplition(nil)
                } else  {
                    print("Failed: \(response)")
                    handlerComplition(nil)
                }
            }
        }
                task.resume()
    }
}
extension CartNetwork {
    func postCart(userCart: [String:Any], completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
        guard let url = URL(string: URLService.draftCart()) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userCart, options: .prettyPrinted)
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
extension CartNetwork{
    
    
     static func CartfetchData(url : String?,handlerComplition : @escaping (ShoppingCart?)->Void) {
     AF.request("\(url!)").responseData {response in
             guard let data = response.data else {
                 return
             }
             
             do{
                 let result = try JSONDecoder().decode(ShoppingCart.self, from: data)
                 handlerComplition(result)
             }catch let error {
                 print(error.localizedDescription)
                 handlerComplition(nil)
             }
             
           }
       }
    
    
    
    
    
    
}
extension CartNetwork {
    
        func putCart(userCart: ShoppingCartPut , completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
            let cartId = UserDefaultsManager.sharedInstance.getUserCart()!
            guard let url = URL(string: URLService.putCart(lineId:cartId)) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let session = URLSession.shared
            request.httpShouldHandleCookies = false
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: userCart.asDictionary(), options: .prettyPrinted)
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
