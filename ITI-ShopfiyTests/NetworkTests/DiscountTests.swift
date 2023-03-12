//
//  DiscountTests.swift
//  ITI-ShopfiyTests
//
//  Created by MESHO on 11/03/2023.
//

import XCTest
@testable import ITI_Shopfiy

final class DiscountTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testFetchDiscounts() throws{
        let expectaion = expectation(description: "Waiting for the API to get Discounts")
        DiscountNetwork.discountfetchData(url: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com//admin/api/2023-01/price_rules/1377368047897/discount_codes.json") { result in
            guard let discounts = result?.discount_codes else
            {
                XCTFail("No Data")
                XCTAssertNil(result)
                expectaion.fulfill()
                return
            }
            XCTAssertNotNil(discounts)
            XCTAssertNotEqual(discounts.count, 0)
            expectaion.fulfill()
        }
        waitForExpectations(timeout: 3 , handler: nil)
    }
    
    
    

}
