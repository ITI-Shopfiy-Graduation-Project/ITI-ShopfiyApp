//
//  CategoryMockingFromNetwork.swift
//  ITI-ShopfiyTests
//
//  Created by MESHO on 11/03/2023.
//

import XCTest
import Foundation
@testable import ITI_Shopfiy

final class CategoryMockingFromNetwork: XCTestCase {
    
    var category: MockingTests?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        category = MockingTests()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        category = nil
    }
    
    
    
    func testLoadDataFromURL(){
        category?.getProductsFromCategory(url: "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com//admin/api/2023-01/custom_collections/437787230489.json?ids=", completionHandler: { (items, error) in
            guard let items = items else {
                XCTFail()
                return
            }
            XCTAssertNotEqual(items.count, 0, "API Failed")
            XCTAssertNotNil(items)
        })

    }

    
    

}
