//
//  MDLibApiTests+Manga.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testGetMangaList() throws {
        let mangaExpectation = self.expectation(description: "Get a list of mangas")
        api.getMangaList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSearchMangas() throws {
        let filter = MDMangaFilter(title: "Solo leveling")
        filter.createdAtSince = .init(timeIntervalSince1970: 0)

        let expectation = self.expectation(description: "Get a list of mangas")
        api.searchMangas(filter: filter) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaTagList() throws {
        let expectation = self.expectation(description: "Get a list of manga tags")
        api.getMangaTagList { (results, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(results)
            XCTAssert(results!.count > 0)
            XCTAssertNotNil(results?.first?.object)
            XCTAssertNotNil(results?.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetRandomManga() throws {
        let expectation = self.expectation(description: "Get a random manga")
        api.getRandomManga { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object)
            XCTAssertNotNil(result?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testViewManga() throws {
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let expectation = self.expectation(description: "Get the manga's information")
        api.viewManga(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.title.translations.first?.value, "Solo Leveling")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testFollowUnfollowManga() throws {
        throw XCTSkip("The API is currently in readonly mode")

        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "0001183c-2089-48e9-96b7-d48db5f1a611" // Eight

        // Assume the manga isn't part of the follow list and start following it
        let followExpectation = self.expectation(description: "Follow the manga")
        api.followManga(mangaId: mangaId) { (error) in
            XCTAssertNil(error)
            followExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the user's followed mangas and check it was added
        let listFollowExpectation1 = self.expectation(description: "List the user's followed mangas")
        api.getLoggedUserFollowedMangaList { (result, error) in
            XCTAssertNil(error)

            var followedMangaIds: [String] = []
            for manga in result?.results ?? [] {
                followedMangaIds.append(manga.object?.objectId ?? "")
            }
            XCTAssertTrue(followedMangaIds.contains(mangaId))
            listFollowExpectation1.fulfill()
        }

        // Unfollow the manga to cleanup
        let unfollowExpectation = self.expectation(description: "Unfollow the manga")
        api.unfollowManga(mangaId: mangaId) { (error) in
            XCTAssertNil(error)
            unfollowExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the user's follow mangas and check it was removed
        let listFollowExpectation2 = self.expectation(description: "List the user's followed mangas")
        api.getLoggedUserFollowedMangaList { (result, error) in
            XCTAssertNil(error)

            var followedMangaIds: [String] = []
            for manga in result?.results ?? [] {
                followedMangaIds.append(manga.object?.objectId ?? "")
            }
            XCTAssertFalse(followedMangaIds.contains(mangaId))
            listFollowExpectation2.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaFeed() throws {
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let expectation = self.expectation(description: "Get the manga's chapters")
        api.getMangaFeed(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaReadMarkers() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let expectation = self.expectation(description: "Get the manga's list of read chapters")
        api.getMangaReadMarkers(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.chapters)
            XCTAssert(result!.chapters!.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetReadingStatuses() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let expectation = self.expectation(description: "Get the list of manga statuses")
        api.getReadingStatuses { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.statuses)
            XCTAssert(result!.statuses!.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaReadingStatus() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let expectation = self.expectation(description: "Get the manga's reading status")
        api.getMangaReadingStatus(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
