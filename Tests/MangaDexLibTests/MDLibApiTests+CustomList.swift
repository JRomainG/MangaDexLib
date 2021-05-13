//
//  MDLibApiTests+CustomList.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testViewCustomList() throws {
        throw XCTSkip("There are no custom lists for the test users")

        try login(api: api, credentialsKey: "AuthRegular")
        let listId = "497f6eca-6276-4993-bfeb-53cbbbba6f08"
        let expectation = self.expectation(description: "Get the custom list's information")
        api.viewCustomList(listId: listId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.name, "ONE")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetCustomListFeed() throws {
        throw XCTSkip("There are no custom lists for the test users")

        try login(api: api, credentialsKey: "AuthRegular")
        let listId = "497f6eca-6276-4993-bfeb-53cbbbba6f08"
        let expectation = self.expectation(description: "Get the custom list's information")
        api.getCustomListFeed(listId: listId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
