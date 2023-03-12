//
//  BrandsTests.swift
//  ITI-ShopfiyTests
//
//  Created by MESHO on 11/03/2023.
//

import XCTest
@testable import ITI_Shopfiy

final class BrandsTests: XCTestCase {

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testFetchBrands() throws{
        let expectaion = expectation(description: "Waiting for the API to get Brands")
        BrandsNetwork.brandsfetchData(url: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/smart_collections.json?since_id=482865238") { result in
            guard let brands = result?.smart_collections else
            {
                XCTFail("No Data")
                XCTAssertNil(result)
                expectaion.fulfill()
                return
            }
            XCTAssertNotNil(brands)
            XCTAssertNotEqual(brands.count, 0)
            expectaion.fulfill()
        }
        waitForExpectations(timeout: 3 , handler: nil)
    }
    
    
    

}
