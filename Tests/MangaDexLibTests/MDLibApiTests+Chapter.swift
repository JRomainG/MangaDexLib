//
//  MDLibApiTests+Chapter.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testGetChapterList() throws {
        let expectation = self.expectation(description: "Get a list of chapters")
        api.getChapterList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

	func testSearchChapters() throws {
		throw XCTSkip("Chapter search is currently broken in the official API")

		let filter = MDChapterFilter(title: "Oneshot")
		filter.createdAtSince = .init(timeIntervalSince1970: 0)
		filter.limit = 3
		filter.offset = 7

		let expectation = self.expectation(description: "Get a list of chapters")
		api.getChapterList(filter: filter) { (result, error) in
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
	
	func testGetChapterForManga() throws {
		let mangaId = "0cf91ce5-5033-4fce-8687-b14c6a4d10b6" //Hone Dragon no Mana Musume
		let filter = MDChapterFilter()
		filter.limit = 1
		filter.manga = mangaId

		let expectation = self.expectation(description: "Get a list of chapters for a specific manga with populated scanlationGroup")
		
		api.getChapterList(filter: filter, includes: [.scanlationGroup]) { (result, error) in
			XCTAssertNil(error)
			XCTAssert(result!.results.count > 0)
			XCTAssert(result!.results.count > 0)
			XCTAssertNotNil(result!.results.first?.object)
			let scanlationGroup = result!.results.first?
				.relationships?
				.first(where: { $0.objectType == .scanlationGroup })?
				.data as? MDGroup
			
			XCTAssertNotNil(scanlationGroup)
			expectation.fulfill()
		}
		waitForExpectations(timeout: 15, handler: nil)
	}

    func testViewChapter() throws {
        let chapterId = "946577a4-d469-45ed-8400-62f03ce4942e" // Solo leveling volume 1 chapter 1 (en)
        let expectation = self.expectation(description: "Get the chapter's information")
        api.viewChapter(chapterId: chapterId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.volume, "1")
            XCTAssertEqual(result?.object?.data.chapter, "1")
            XCTAssertEqual(result?.object?.data.language, Locale.init(identifier: "en"))
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetChapterPages() throws {
        let chapterId = "946577a4-d469-45ed-8400-62f03ce4942e" // Solo leveling volume 1 chapter 1 (en)

        // Start by getting information about the chapter
        var chapter: MDChapter?
        let mangaExpectation = self.expectation(description: "Get the chapter's information")
        api.viewChapter(chapterId: chapterId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.volume, "1")
            XCTAssertEqual(result?.object?.data.chapter, "1")
            XCTAssertEqual(result?.object?.data.language, Locale.init(identifier: "en"))
            chapter = result?.object?.data
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Now, find out where the chapter's pages are hosted
        var node: MDAtHomeNode?
        let nodeExpectation = self.expectation(description: "Get the chapter's MD@Home node")
        api.getChapterServer(chapterId: chapterId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            node = result
            nodeExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Finally, make sure nothing failed and build the full URLs for this chapter's pages
        guard chapter != nil, node != nil else {
            return
        }
        let urls = chapter?.getPageUrls(node: node!, lowRes: false)
        XCTAssertNotNil(urls)
        XCTAssert(urls!.count > 0)
    }

    func testMarkUnmarkChapter() throws {
        throw XCTSkip("The API is currently in readonly mode")

        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "0001183c-2089-48e9-96b7-d48db5f1a611" // Boku No Hero Academia
        let chapterId = "cb46d8e3-629b-461e-97e3-594f3ac9c982" // Volume 23 chapter 224 (de)

        // Assume the chapter wasn't read by the test user
        let readExpectation = self.expectation(description: "Mark the chapter as read")
        api.markChapterRead(chapterId: chapterId) { (error) in
            XCTAssertNil(error)
            readExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the manga's read markers and check it's included
        let listReadExpectation1 = self.expectation(description: "List the manga's read chapters")
        api.getMangaReadMarkers(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result?.chapters)
            XCTAssertTrue(result!.chapters!.contains(chapterId))
            listReadExpectation1.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Unfollow the manga to cleanup
        let unreadExpectation = self.expectation(description: "Mark the chapter as unread")
        api.markChapterUnread(chapterId: chapterId) { (error) in
            XCTAssertNil(error)
            unreadExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the manga's read markers and check it was removed
        let listReadExpectation2 = self.expectation(description: "List the manga's read chapters")
        api.getMangaReadMarkers(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result?.chapters)
            XCTAssertFalse(result!.chapters!.contains(chapterId))
            listReadExpectation2.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
