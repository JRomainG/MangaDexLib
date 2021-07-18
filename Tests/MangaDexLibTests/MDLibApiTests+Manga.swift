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
        let filter = MDMangaFilter(title: "Solo")
        filter.createdAtSince = .init(timeIntervalSince1970: 0)
        filter.limit = 8
        filter.offset = 22

        let expectation = self.expectation(description: "Get a list of mangas")
        api.getMangaList(filter: filter) { (result, error) in
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

    func testMangaListReferenceExpansion() throws {
        let includes: [MDObjectType] = [
            .author, .artist, .coverArt
        ]
        let mangaExpectation = self.expectation(description: "Get a list of mangas")
        api.getMangaList(includes: includes) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            for manga in result!.results {
                XCTAssertNotNil(manga.relationships)
                XCTAssertNotNil(manga.object)
                XCTAssertNotNil(manga.object?.data)

                // Make sure all requested object types were included
                let relationshipTypes = manga.relationships!.map { $0.objectType }
                for objType in includes {
                    XCTAssert(relationshipTypes.contains(objType))
                }

                // Make sure only requested object types were included and data was correctly decoded
                for relationship in manga.relationships ?? [] {
                    XCTAssert(includes.contains(relationship.objectType))
                    XCTAssertNotNil(relationship.data)
                }

            }
            mangaExpectation.fulfill()
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
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        let expectation = self.expectation(description: "Get the manga's information")
        api.viewManga(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.title.translations.first?.value, "Official \"Test\" Manga")
            XCTAssertEqual(result?.object?.data.altTitles.first?.translations.first?.value, "TEST")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testFollowUnfollowManga() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga

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

        // Wait for a bit, otherwise unfollowing will fail
        usleep(1000000)

        // Unfollow the manga to cleanup
        let unfollowExpectation = self.expectation(description: "Unfollow the manga")
        api.unfollowManga(mangaId: mangaId) { (error) in
            XCTAssertNil(error)
            unfollowExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the user's followed mangas and check it was removed
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
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
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

    func testGetMangaVolumesAndChapters() throws {
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        let expectation = self.expectation(description: "Get the manga's aggregated data")
        api.getMangaVolumesAndChapters(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.volumes.count > 0)
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

    func testGetMangasReadMarkers() throws {
        // Assume the test account has marked some chapters from one of these mangas as read
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaIds = [
            "f9c33607-9180-4ba6-b85c-e4b5faee7192", // Official "Test" Manga
            "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        ]
        let expectation = self.expectation(description: "Get the mangas' list of read chapters")
        api.getMangasReadMarkers(mangaIds: mangaIds) { (result, error) in
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
        // Assume the test account has set a reading status for this manga
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

    func testGetMangaNoReadingStatus() throws {
        // Assume the test account has NOT set a reading status for this manga
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        let expectation = self.expectation(description: "Get the manga's reading status")
        api.getMangaReadingStatus(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
