//
//  MDLibApiTests.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import XCTest
@testable import MangaDexLib

class MDLibApiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func assertMangaListIsValid(for response: MDResponse) {
        XCTAssert(response.type == .mangaList)
        XCTAssertNil(response.error)
        XCTAssertNotNil(response.rawValue)
        XCTAssertNotNil(response.mangas)
        XCTAssertGreaterThan(response.mangas!.count, 0)
    }

    func assertCommentListIsValid(for response: MDResponse) {
        XCTAssert(response.type == .commentList)
        XCTAssertNotNil(response.comments)
        XCTAssert(response.comments!.count > 0)
        XCTAssertNotNil(response.comments?.first?.body)
        assertUserIsValid(response.comments?.first?.user)
    }

    func assertUserIsValid(_ user: MDUser?) {
        XCTAssertNotNil(user)
        XCTAssertNotNil(user?.name)
        XCTAssertNotNil(user?.rank)
        XCTAssertNotNil(user?.avatar)
    }

    func testListedMangas() throws {
        let api = MDApi()
        let expectation = self.expectation(description: "Load MangaDex titles page")

        api.getListedMangas(page: 1, sort: .bestRating) { (response) in
            self.assertMangaListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testFeaturedMangas() throws {
        let api = MDApi()
        let expectation = self.expectation(description: "Load MangaDex featured page")

        api.getFeaturedMangas { (response) in
            self.assertMangaListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testLatestMangas() throws {
        let api = MDApi()
        let expectation = self.expectation(description: "Load MangaDex latest updates page")

        api.getLatestMangas(page: 1) { (response) in
            self.assertMangaListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testMangaSearch() throws {
        let api = MDApi()
        let search = MDSearch(title: "Tower of God")
        let expectation = self.expectation(description: "Load MangaDex search page")

        // Searching is disabled when logged out, so this will return the login page
        api.performSearch(search) { (_) in
            // TODO: Detect login
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testRandomManga() throws {
        let api = MDApi()
        let expectation = self.expectation(description: "Load random manga page")

        api.getRandomManga { (response) in
            XCTAssert(response.type == .mangaInfo)
            XCTAssertNotNil(response.manga)
            XCTAssertNotNil(response.manga?.mangaId)
            XCTAssertNotNil(response.manga?.title)
            XCTAssertNotNil(response.manga?.coverUrl)
            XCTAssertNotNil(response.manga?.description)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testMangaComments() throws {
        let mangaId = 7139
        let mangaTitle = "One Punch Man"
        let manga = MDManga(title: mangaTitle, mangaId: mangaId)
        let api = MDApi()
        let expectation = self.expectation(description: "Load a manga's comments")

        api.getMangaComments(manga: manga) { (response) in
            self.assertCommentListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testChapterComments() throws {
        let chapterId = 867036 // One Punch Man chapter 131
        let chapter = MDChapter(chapterId: chapterId)
        let api = MDApi()
        let expectation = self.expectation(description: "Load a chapter's comments")

        api.getChapterComments(chapter: chapter) { (response) in
            self.assertCommentListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testThread() throws {
        let threadId = 237699 // One Punch Man chapter 131 thread
        let page = 8
        let api = MDApi()
        let expectation = self.expectation(description: "Load a chapter's comments")

        api.getThread(threadId: threadId, page: page) { (response) in
            self.assertCommentListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
