//
//  AddressNetwork.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 03/03/2023.
//

import Foundation
import Alamofire

class AddressNetwork : IAdressNetwork{
    
    static var sharedInstance = AddressNetwork()
    private init(){}
    
    func postAddress(userAddress: PostAddress, completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
        guard let url = URL(string: URLService.postAddress(userID: userAddress.customer_address.customer_id ?? 1)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userAddress.asDictionary(), options: .prettyPrinted)
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
    
    func fetchAllUserAddresses(userId: Int,handlerComplition : @escaping (CustomerAddress?)->()) {
       
            let request = AF.request("https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/customers/\(userId)/addresses.json")
            request.responseDecodable (of: CustomerAddress.self) {(olddata) in
                guard let data = olddata.value
                else{
                    handlerComplition(nil)
                    return
                }
                handlerComplition(data)
            }
      }
}
