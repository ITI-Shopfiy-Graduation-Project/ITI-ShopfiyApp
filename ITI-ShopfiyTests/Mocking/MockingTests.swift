//
//  MockingTests.swift
//  ITI-ShopfiyTests
//
//  Created by MESHO on 12/03/2023.
//

import Foundation
@testable import ITI_Shopfiy

class MockingTests{
    
    let categoryFetch: String = "{\"products\":[{\"id\":8117840150809,\"title\":\"ADIDAS | SUPERSTAR 80S\",\"body_html\":\"There's a shell toe for every season, and the adidas Originals Superstar 80s shoes have a full grain leather upper with a shiny badge on the tongue that makes these shoes ready for any time of year.\",\"vendor\":\"ADIDAS\",\"product_type\":\"SHOES\",\"created_at\":\"2023-02-15T02:31:23-05:00\",\"handle\":\"adidas-superstar-80s\",\"updated_at\":\"2023-02-15T02:40:30-05:00\",\"published_at\":\"2023-02-15T02:31:23-05:00\",\"template_suffix\":null,\"status\":\"active\",\"published_scope\":\"web\",\"tags\":\"adidas, autumn, egnition-sample-data, men, spring, summer\",\"admin_graphql_api_id\":\"gid:\\/\\/shopify\\/Product\\/8117840150809\",\"variants\":[{\"id\":44567226777881,\"product_id\":8117840150809,\"title\":\"5 \\/ white\",\"price\":\"170.00\",\"sku\":\"AD-01-white-5\",\"position\":1,\"inventory_policy\":\"deny\",\"compare_at_price\":null,\"fulfillment_service\":\"manual\",\"inventory_management\":\"shopify\",\"option1\":\"5\",\"option2\":\"white\",\"option3\":null,\"created_at\":\"2023-02-15T02:31:24-05:00\",\"updated_at\":\"2023-02-15T02:33:35-05:00\",\"taxable\":true,\"barcode\":null,\"grams\":0,\"image_id\":null,\"weight\":0.0,\"weight_unit\":\"kg\",\"inventory_item_id\":46616130191641,\"inventory_quantity\":15,\"old_inventory_quantity\":15,\"requires_shipping\":true,\"admin_graphql_api_id\":\"gid:\\/\\/shopify\\/ProductVariant\\/44567226777881\"}],\"options\":[{\"id\":10319211495705,\"product_id\":8117840150809,\"name\":\"Size\",\"position\":1,\"values\":[\"5\",\"6\",\"7\",\"9\",\"10\",\"11\",\"12\"]}],\"images\":[{\"id\":40585991913753,\"product_id\":8117840150809,\"position\":1,\"created_at\":\"2023-02-15T02:31:23-05:00\",\"updated_at\":\"2023-02-15T02:31:23-05:00\",\"alt\":null,\"width\":635,\"height\":560,\"src\":\"https:\\/\\/cdn.shopify.com\\/s\\/files\\/1\\/0721\\/3963\\/7017\\/products\\/44694ee386818f3276566210464cf341.jpg?v=1676446283\",\"variant_ids\":[],\"admin_graphql_api_id\":\"gid:\\/\\/shopify\\/ProductImage\\/40585991913753\"}]}]}"
    
    
    func getProductsFromCategory(url: String, completionHandler: @escaping ([Products]?, Error?) -> Void) {
        NetworkServices.fetchData(url: url) {_ in
            let data = Data(self.categoryFetch.utf8)
            do {
                let response = try JSONDecoder().decode(ProductResult.self, from: data)
                completionHandler(response.products, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
}
