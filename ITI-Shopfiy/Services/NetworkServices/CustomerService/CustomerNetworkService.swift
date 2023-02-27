//
//  CustomerNetworkService.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 28/02/2023.
//

import Foundation
import Alamofire

class CustomerRegister: PUT_REGISTER{
    static func registerCustomer(newCustomer: NewCustomer, completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
        guard let url = URL(string: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/customers.json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newCustomer.asDictionary(), options: .prettyPrinted)
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



class CustomerLogin: GET_LOGIN{
    static func login(user_name: String, password: String, completionHandler: @escaping (LoginResponse?) -> Void) {
        guard let url = URL(string: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/customers.json") else {
            completionHandler(nil)
            return
        }
        AF.request(url).responseData {response in
                guard let data = response.data else {
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completionHandler(result)
                }catch let error {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
                
              }
        
    }
    
}
