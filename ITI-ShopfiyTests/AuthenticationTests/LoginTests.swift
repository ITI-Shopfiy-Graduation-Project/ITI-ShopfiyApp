//
//  LoginTests.swift
//  ITI-ShopfiyTests
//
//  Created by MESHO on 11/03/2023.
//

import XCTest
@testable import ITI_Shopfiy

final class LoginTests: XCTestCase {

    var loginAuthentication: loginProtocol?
    
    var customer1Email: String?
    var customer1Password: String?
    
    var customer2Email: String?
    var customer2Password: String?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginAuthentication = LoginVM()
        
        customer1Email = "fedo"
        customer1Password = "123"
        
        customer2Email = "maamoun22@mo2.com"
        customer2Password = "123456"
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginAuthentication = nil
        
        customer1Email = ""
        customer1Password = ""
        
        customer2Email = ""
        customer2Password = ""
        
    }

    
    func testAuthentication1(){
        let result = true
        if result == loginAuthentication?.isValidPassword(password: customer1Password ?? "123"){
            XCTAssertTrue(result == true)
        }else{
            XCTFail("Fail with error")
        }
    }

    func testAuthentication2(){
        let result = true
        if result == loginAuthentication?.isValidPassword(password: customer2Password ?? "12345"){
            XCTAssertTrue(result == true)
        }else{
            XCTFail("Fail with error")
        }
    }
    
    func testAuthentication3() throws{
        let expectaion = expectation(description: "Waiting for the API to get customer report")
        loginAuthentication?.login(userName: customer1Email ?? "fedo", password: customer1Password ?? "123", completionHandler: { Customer in
            if Customer != nil {
                guard let customer = Customer else
                {
                    XCTFail("No Data")
                    XCTAssertNil(Customer)
                    expectaion.fulfill()
                    return
                }
                XCTAssertNotNil(customer)
                XCTAssertEqual(customer.email,self.customer1Email )
                XCTAssertEqual(customer.tags,self.customer1Password )
                expectaion.fulfill()
            }else{
                XCTFail("please check your Email or Password")
                XCTFail("failed to login")
                expectaion.fulfill()
                return
            }
        })
        waitForExpectations(timeout: 3 , handler: nil)
    }
    
    
    func testAuthentication4() throws{
        let expectaion = expectation(description: "Waiting for the API to get customer report")
        loginAuthentication?.login(userName: customer2Email ?? "abdo22@iti.com", password: customer2Password ?? "12345", completionHandler: { Customer in
            if Customer != nil {
                guard let customer = Customer else
                {
                    XCTFail("No Data")
                    XCTAssertNil(Customer)
                    expectaion.fulfill()
                    return
                }
                XCTAssertNotNil(customer)
                XCTAssertEqual(customer.email,self.customer2Email )
                XCTAssertEqual(customer.tags,self.customer2Password )
                expectaion.fulfill()
            }else{
                XCTFail("please check your Email or Password")
                XCTFail("failed to login")
                expectaion.fulfill()
                return
            }
        })
        waitForExpectations(timeout: 3 , handler: nil)
        
    }
    

}
