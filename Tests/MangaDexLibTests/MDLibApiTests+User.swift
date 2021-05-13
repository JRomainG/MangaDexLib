//
//  MDLibApiTests+User.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testViewUser() throws {
        let userId = "3413e092-d036-45e3-ae1a-0d0c6275a292" // MangaDexLib
        let expectation = self.expectation(description: "Get the user's information")
        api.viewUser(userId: userId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.username, "MangaDexLib")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetUserCustomLists() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let userId = "3413e092-d036-45e3-ae1a-0d0c6275a292" // MangaDexLib
        let expectation = self.expectation(description: "Get the user's custom lists")
        api.getUserCustomLists(userId: userId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.results)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testViewLoggedUser() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let expectation = self.expectation(description: "Get the user's information")
        api.viewLoggedUser { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetLoggedUserFollowedMangaList() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let expectation = self.expectation(description: "Get the user's followed mangas")
        api.getLoggedUserFollowedMangaList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.results)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetLoggedUserFollowedMangaFeed() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let expectation = self.expectation(description: "Get the user's followed manga feed")
        api.getLoggedUserFollowedMangaFeed { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.results)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetLoggedUserFollowedGroupList() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let expectation = self.expectation(description: "Get the user's list of followed groups")
        api.getLoggedUserFollowedGroupList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.results)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetLoggedUserFollowedUserList() throws {
        throw XCTSkip("This endpoint seems to be broken in the API")

        try login(api: api, credentialsKey: "AuthRegular")
        let expectation = self.expectation(description: "Get the user's list of followed users")
        api.getLoggedUserFollowedUserList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.results)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetLoggedUserCustomLists() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let expectation = self.expectation(description: "Get the user's list of custom lists")
        api.getLoggedUserCustomLists { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.results)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
