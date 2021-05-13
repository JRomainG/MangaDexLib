//
//  MDLibApiTests+Group.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testGetScanlationGroupList() throws {
        let api = MDApi()
        let groupExpectation = self.expectation(description: "Get a list of scanlation groups")
        api.getGroupList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            groupExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSearchScanlationGroups() throws {
        let api = MDApi()
        let filter = MDGroupFilter(name: "mangadex")

        let groupExpectation = self.expectation(description: "Get a list of scanlation groups")
        api.searchGroups(filter: filter) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            groupExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testViewScanlationGroup() throws {
        let api = MDApi()
        let groupId = "b8a6d1fc-1634-47a8-98cf-2ea3f5fef8b3" // MangaDex Scans
        let groupExpectation = self.expectation(description: "Get the scanlation group's information")
        api.viewGroup(groupId: groupId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.name, "MangaDex Scans")
            XCTAssertEqual(result?.object?.data.leader.objectId, "17179fd6-77fb-484a-a543-aaea12511c07")
            XCTAssert(result!.object!.data.members.count > 0)
            groupExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
