//
//  MDLibApiTests+Author.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testGetAuthorList() throws {
        let expectation = self.expectation(description: "Get a list of authors")
        api.getAuthorList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSearchAuthors() throws {
        let filter = MDAuthorFilter(name: "ONE")
        filter.limit = 4
        filter.offset = 0

        let expectation = self.expectation(description: "Get a list of authors")
        api.getAuthorList(filter: filter) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            XCTAssertEqual(result?.limit, filter.limit)
            XCTAssertEqual(result?.offset, filter.offset)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testViewAuthor() throws {
        let authorId = "16b98239-6452-4859-b6df-fdb1c7f12b52" // ONE
        let expectation = self.expectation(description: "Get the author's information")
        api.viewAuthor(authorId: authorId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.name, "ONE")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
