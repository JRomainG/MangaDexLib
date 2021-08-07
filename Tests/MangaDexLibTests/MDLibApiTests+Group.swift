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
        let expectation = self.expectation(description: "Get a list of scanlation groups")
        api.getGroupList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSearchScanlationGroups() throws {
        let filter = MDGroupFilter(name: "mangadex")
        filter.limit = 2
        filter.offset = 1

        let expectation = self.expectation(description: "Get a list of scanlation groups")
        api.getGroupList(filter: filter) { (result, error) in
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

    func testViewScanlationGroup() throws {
        let groupId = "b8a6d1fc-1634-47a8-98cf-2ea3f5fef8b3" // MangaDex Scans
        let expectation = self.expectation(description: "Get the scanlation group's information")
		api.viewGroup(groupId: groupId, includes: [.member, .leader]) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.name, "MangaDex Scans")
			guard let leader = result!.relationships?.first(where: { $0.objectType == .leader }) else {
				return XCTFail("leader not found")
			}
            XCTAssertEqual(leader.objectId, "17179fd6-77fb-484a-a543-aaea12511c07")
			
			guard let members = result!.relationships?.filter({ $0.objectType == .member }) else {
				return XCTFail("members not found")
			}
			XCTAssert(members.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testFollowUnfollowGroup() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let groupId = "b8a6d1fc-1634-47a8-98cf-2ea3f5fef8b3" // MangaDex Scans

        // Assume the user doesn't follow this group yet and start following it
        let followExpectation = self.expectation(description: "Follow the scanlation group")
        api.followGroup(groupId: groupId) { (error) in
            XCTAssertNil(error)
            followExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the user's followed groups and check it was added
        let listFollowExpectation1 = self.expectation(description: "List the user's followed scanlation group")
        api.getLoggedUserFollowedGroupList { (result, error) in
            XCTAssertNil(error)

            var followedGroupIds: [String] = []
            for group in result?.results ?? [] {
                followedGroupIds.append(group.object?.objectId ?? "")
            }
            XCTAssertTrue(followedGroupIds.contains(groupId))
            listFollowExpectation1.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Wait for a bit, otherwise unfollowing will fail
        usleep(1000000)

        // Unfollow the group to cleanup
        let unfollowExpectation = self.expectation(description: "Unfollow the scanlation group")
        api.unfollowGroup(groupId: groupId) { (error) in
            XCTAssertNil(error)
            unfollowExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the user's follow groups and check it was removed
        let listFollowExpectation2 = self.expectation(description: "List the user's followed scanlation group")
        api.getLoggedUserFollowedGroupList { (result, error) in
            XCTAssertNil(error)

            var followedGroupIds: [String] = []
            for group in result?.results ?? [] {
                followedGroupIds.append(group.object?.objectId ?? "")
            }
            XCTAssertFalse(followedGroupIds.contains(groupId))
            listFollowExpectation2.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
