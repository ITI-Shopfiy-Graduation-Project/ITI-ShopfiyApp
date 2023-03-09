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
        guard let url = URL(string: URLService.postAddress(userID: userAddress.customer_address?.customer_id ?? 1)) else { return }
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
    /*
    func deleteMethod(address : Address completionHandler:@escaping (Data?, URLResponse? , Error?)->()) {
        guard let url = URL(string: URLService.deleteAddress(addressID: address.id ?? -1, userId: address.customer_id ?? -1)) else {
                print("Error: cannot create URL")
                return
            }
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: address.asDictionary(), options: .prettyPrinted)
                    print("address deleted")
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }*/
        
    func deleteAddress(userAddress : PostAddress,completion: @escaping (Data?, URLResponse?, Error?) -> ()){
        let userID = UserDefaultsManager.sharedInstance.getUserID()
        let addressId = userAddress.customer_address?.id
        print ("IDDDD : \(userID) , \(addressId) ")
        let url = URLService.deleteAddress(addressID: addressId ?? 0, userId: userID ?? 0)
        guard let baseURL = URL(string : url ?? "") else { return }
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
                                print("Error: HTTP request failed \(response)")
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
    
    /*
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
      }*/
    func fetchAllUserAddresses(userId: Int,handlerComplition : @escaping (CustomerAddress?)->()) {
        AF.request("https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/customers/\(userId)/addresses.json").responseData {response in
            guard let data = response.data else {
                return
            }
            do{
                let result = try JSONDecoder().decode(CustomerAddress.self, from: data)
                handlerComplition(result)
            }catch let error {
                print(error.localizedDescription)
                handlerComplition(nil)
            }
        }
    }
    
  /*  func putCustomer(userOrder: [String: Any], url: String, completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.uploadTask()
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
    */
    

}
