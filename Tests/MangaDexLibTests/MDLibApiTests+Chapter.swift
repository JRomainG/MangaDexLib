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
        let api = MDApi()
        let chapterExpectation = self.expectation(description: "Get a list of chapters")
        api.getChapterList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            chapterExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSearchChapters() throws {
        let api = MDApi()
        let filter = MDChapterFilter(title: "Oneshot")
        filter.createdAtSince = .init(timeIntervalSince1970: 0)

        let chapterExpectation = self.expectation(description: "Get a list of chapters")
        api.searchChapters(filter: filter) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first?.object)
            XCTAssertNotNil(result?.results.first?.object?.data)
            chapterExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testViewChapter() throws {
        let api = MDApi()
        let chapterId = "946577a4-d469-45ed-8400-62f03ce4942e" // Solo leveling volume 1 chapter 1 (en)
        let mangaExpectation = self.expectation(description: "Get the chapter's information")
        api.viewChapter(chapterId: chapterId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.object?.data)
            XCTAssertEqual(result?.object?.data.volume, "1")
            XCTAssertEqual(result?.object?.data.chapter, "1")
            XCTAssertEqual(result?.object?.data.language, Locale.init(identifier: "en"))
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetChapterServer() throws {
        let api = MDApi()
        let chapterId = "946577a4-d469-45ed-8400-62f03ce4942e" // Solo leveling volume 1 chapter 1 (en)
        let nodeExpectation = self.expectation(description: "Get the chapter's MD@Home node")
        api.getChapterServer(chapterId: chapterId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            nodeExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetChapterPages() throws {
        let api = MDApi()
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

}
