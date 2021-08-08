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
        try login(api: api, credentialsKey: "AuthRegular")

        let info = MDCustomList(name: "Test list", visibility: .privateList, mangas: [
            "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        ])
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
                customListIds.append(list.objectId)
            }
            XCTAssertTrue(customListIds.contains(createdListId!))
            listExpectation1.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Wait for a bit, otherwise deleting will fail
        usleep(1000000)

        // Delete the newly created list
        let deleteExpectation = self.expectation(description: "Delete a custom list")
        api.deleteCustomList(listId: createdListId!) { (error) in
            XCTAssertNil(error)
            deleteExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Make sure it was removed from the user's custom lists
        // It seems like propagating a delete takes some time, so checking this right away would fail
        /*
        let listExpectation2 = self.expectation(description: "List the user's custom list")
        api.getLoggedUserCustomLists { (result, error) in
            XCTAssertNil(error)

            var customListIds: [String] = []
            for list in result?.results ?? [] {
                customListIds.append(list.objectId)
            }
            XCTAssertFalse(customListIds.contains(createdListId!))
            listExpectation2.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        */
    }

    func testViewCustomList() throws {
        let listId = "a153b4e6-1fcc-4f45-a990-f37f989c0d74" // MangaDex summer 2021 list
        let expectation = self.expectation(description: "Get the custom list's information")
        api.viewCustomList(listId: listId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.name, "Seasonal: Summer 2021")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testCustomListReferenceExpansion() throws {
        let listId = "a153b4e6-1fcc-4f45-a990-f37f989c0d74" // MangaDex summer 2021 list
        let expectation = self.expectation(description: "Get the custom list's information")
        api.viewCustomList(listId: listId, includes: [.user]) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.name, "Seasonal: Summer 2021")
            let owner = result?.relationships?.first(where: { (relationship) -> Bool in
                return relationship.objectType == .user
            })
            XCTAssertEqual(owner?.objectId, "d2ae45e0-b5e2-4e7f-a688-17925c2d7d6b") // MangaDex
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetCustomListFeed() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let listId = "a153b4e6-1fcc-4f45-a990-f37f989c0d74" // MangaDex summer 2021 list
        let expectation = self.expectation(description: "Get the custom list's feed")
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
