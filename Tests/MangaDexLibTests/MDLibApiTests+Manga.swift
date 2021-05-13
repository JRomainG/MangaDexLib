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
        let api = MDApi()
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
        let api = MDApi()
        let filter = MDMangaFilter(title: "Solo leveling")
        filter.createdAtSince = .init(timeIntervalSince1970: 0)

        let chapterExpectation = self.expectation(description: "Get a list of mangas")
        api.searchMangas(filter: filter) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            chapterExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaTagList() throws {
        let api = MDApi()
        let tagExpectation = self.expectation(description: "Get a list of manga tags")
        api.getMangaTagList { (results, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(results)
            XCTAssert(results!.count > 0)
            XCTAssertNotNil(results?.first?.object)
            XCTAssertNotNil(results?.first?.object?.data)
            tagExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetRandomManga() throws {
        let api = MDApi()
        let mangaExpectation = self.expectation(description: "Get a random manga")
        api.getRandomManga { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object)
            XCTAssertNotNil(result?.object?.data)
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testViewManga() throws {
        let api = MDApi()
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let mangaExpectation = self.expectation(description: "Get the manga's information")
        api.viewManga(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.title.translations.first?.value, "Solo Leveling")
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaFeed() throws {
        let api = MDApi()
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let chapterExpectation = self.expectation(description: "Get the manga's chapters")
        api.getMangaFeed(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            chapterExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaReadMarkers() throws {
        let api = MDApi()
        try ping(api: api)
        try login(api: api, credentialsKey: "AuthRegular")

        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let mangaExpectation = self.expectation(description: "Get the manga's list of read chapters")
        api.getMangaReadMarkers(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.chapters)
            XCTAssert(result!.chapters!.count > 0)
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetReadingStatuses() throws {
        throw XCTSkip("The API documentation for the /manga/status endpoint does not seem to match the implementation")

        let api = MDApi()
        try ping(api: api)
        try login(api: api, credentialsKey: "AuthRegular")

        let mangaExpectation = self.expectation(description: "Get the list of manga statuses")
        api.getReadingStatuses { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.statuses)
            XCTAssert(result!.statuses!.count > 0)
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
