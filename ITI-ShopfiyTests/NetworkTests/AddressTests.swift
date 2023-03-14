//
//  AddressTests.swift
//  ITI-ShopfiyTests
//
//  Created by MESHO on 11/03/2023.
//

import XCTest
@testable import ITI_Shopfiy

final class AddressTests: XCTestCase {
    
    var user1_Id: Int?
    var user2_Id: Int?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        user1_Id = 123
        user2_Id = 6880117391641
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testFetchuserAddresses() throws{
        let expectaion = expectation(description: "Waiting for the API to get Addresses")
        AddressNetwork.sharedInstance.fetchAllUserAddresses(userId: user1_Id ?? 123) {  result in
            if result != nil {
                guard let addresses = result?.addresses else
                {
                    XCTFail("No Data")
                    XCTAssertNil(result)
                    expectaion.fulfill()
                    return
                }
                XCTAssertNotNil(addresses)
                XCTAssertNotEqual(addresses.count, 0)
                expectaion.fulfill()
            }else{
                XCTFail("please check your Email or Password")
                XCTFail("failed to get your addresses in app")
                expectaion.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 3 , handler: nil)
    }
    
    func testFetchuserAddresses2() throws{
        let expectaion = expectation(description: "Waiting for the API to get Addresses")
        AddressNetwork.sharedInstance.fetchAllUserAddresses(userId: user2_Id ?? 6874931691801) {  result in
            if result != nil {
                guard let addresses = result?.addresses else
                {
                    XCTFail("No Data")
                    XCTAssertNil(result)
                    expectaion.fulfill()
                    return
                }
                XCTAssertNotNil(addresses)
                XCTAssertNotEqual(addresses.count, 0)
                expectaion.fulfill()
            }else{
                XCTFail("please check your Email or Password")
                XCTFail("failed to get your addresses in app")
                expectaion.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 3 , handler: nil)
    }
    
    

}
