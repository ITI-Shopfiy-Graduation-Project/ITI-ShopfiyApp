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


extension CartNetwork {
    func deleteCart(completion: @escaping ( Error?) -> ()){
        guard let draftOrderID = UserDefaultsManager.sharedInstance.getUserCart() else { return }
        let url = URLService.deleteCart(cartID: draftOrderID)
        guard let baseURL = URL(string : url ) else { return }
        var request = URLRequest(url: baseURL)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        request.httpShouldHandleCookies = false
        
        do{
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling DELETE")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print(response)
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print("Draft order successfully deleted")
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
