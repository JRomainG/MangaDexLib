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

    func testCreateDeleteCustomList() throws {
        throw XCTSkip("The API is currently in readonly mode")

        try login(api: api, credentialsKey: "AuthRegular")

        let info = MDCustomList(name: "Test list", visibility: .privateList, mangas: [])
        var createdListId: String?

        // Create a new list
        let createExpectation = self.expectation(description: "Create a new custom list")
        api.createCustomList(info: info) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result?.object)
            createdListId = result?.object?.objectId
            createExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        XCTAssertNotNil(createdListId)

        // Make sure it now appears in the user's custom lists
        let listExpectation1 = self.expectation(description: "List the user's custom list")
        api.getLoggedUserCustomLists { (result, error) in
            XCTAssertNil(error)

            var customListIds: [String] = []
            for list in result?.results ?? [] {
                customListIds.append(list.object?.objectId ?? "")
            }
            XCTAssertTrue(customListIds.contains(createdListId!))
            listExpectation1.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Delete the newly created list
        let deleteExpectation = self.expectation(description: "Delete a custom list")
        api.deleteCustomList(listId: createdListId!) { (error) in
            XCTAssertNil(error)
            deleteExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Make sure it was removed from the user's custom lists
        let listExpectation2 = self.expectation(description: "List the user's custom list")
        api.getLoggedUserCustomLists { (result, error) in
            XCTAssertNil(error)

            var customListIds: [String] = []
            for list in result?.results ?? [] {
                customListIds.append(list.object?.objectId ?? "")
            }
            XCTAssertFalse(customListIds.contains(createdListId!))
            listExpectation2.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

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
