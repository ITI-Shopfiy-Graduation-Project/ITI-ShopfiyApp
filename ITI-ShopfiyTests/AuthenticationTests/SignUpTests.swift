//
//  SignUpTests.swift
//  ITI-ShopfiyTests
//
//  Created by MESHO on 11/03/2023.
//

import XCTest
@testable import ITI_Shopfiy

final class SignUpTests: XCTestCase {

    var registerAuthentication: registerProtocol?
    
    var customer1Email: String?
    var customer1Password: String?
    
    var customer2Email: String?
    var customer2Password: String?
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        registerAuthentication = RegisterVM()
        
        customer1Email = "fedo"
        customer1Password = "123"
        
        customer2Email = "fady10@gmail.com"
        customer2Password = "12345"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        registerAuthentication = nil
        
        customer1Email = ""
        customer1Password = ""
        
        customer2Email = ""
        customer2Password = ""
    }
    
    
    func testAuthentication1(){
        let result = true
        if result == registerAuthentication?.isValidEmail(customer1Email ?? "fedo"){
            XCTAssertTrue(result == true)
        }else{
            XCTFail("Fail with error")
        }
    }

    func testAuthentication2(){
        let result = true
        if result == registerAuthentication?.isValidEmail(customer2Email ?? "abdo22@iti.com"){
            XCTAssertTrue(result == true)
        }else{
            XCTFail("Fail with error")
        }
    }
    
    func testAuthentication3(){
        let result = true
        if result == registerAuthentication?.isValidPassword(password: customer1Password ?? "123", confirmPassword: "12"){
            XCTAssertTrue(result == true)
        }else{
            XCTFail("Fail with error")
        }
    }

    func testAuthentication4(){
        let result = true
        if result == registerAuthentication?.isValidPassword(password: customer2Password ?? "12345", confirmPassword: customer2Password ?? "12345"){
            XCTAssertTrue(result == true)
        }else{
            XCTFail("Fail with error")
        }
    }
    
    

    
    
}
