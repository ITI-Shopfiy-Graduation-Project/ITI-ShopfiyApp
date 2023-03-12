//
//  CartTests.swift
//  ITI-ShopfiyTests
//
//  Created by MESHO on 11/03/2023.
//

import XCTest
@testable import ITI_Shopfiy


final class CartTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testFetchCart() throws{
        let expectaion = expectation(description: "Waiting for the API to get Cart")
        CartNetwork.CartfetchData(url: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/draft_orders.json"){ result in
            guard let cartProducts = result?.draft_orders else
            {
                XCTFail("No Data")
                XCTAssertNil(result)
                expectaion.fulfill()
                return
            }
            XCTAssertNotNil(cartProducts)
            XCTAssertNotEqual(cartProducts.count, 0)
            expectaion.fulfill()
        }
        waitForExpectations(timeout: 3 , handler: nil)
    }

    

}
