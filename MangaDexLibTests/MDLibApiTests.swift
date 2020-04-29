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

        for manga in response.mangas! {
            assertMangaIsValid(manga)
        }
    }

    func assertChapterListIsValid(_ chapters: [MDChapter]?) {
        XCTAssertNotNil(chapters)
        XCTAssertGreaterThan(chapters!.count, 0)

        for chapter in chapters! {
            assertChapterIsValid(chapter)
        }
    }

    func assertCommentListIsValid(for response: MDResponse) {
        XCTAssert(response.type == .commentList)
        XCTAssertNil(response.error)
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

    func assertMangaIsValid(_ manga: MDManga?) {
        XCTAssertNotNil(manga)
        XCTAssertNotNil(manga?.mangaId)
    }

    func assertChapterIsValid(_ chapter: MDChapter?) {
        XCTAssertNotNil(chapter)
        XCTAssertNotNil(chapter?.chapterId)
        XCTAssertNotNil(chapter?.mangaId)
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
        let api = MDApi()
        let expectation = self.expectation(description: "Load a manga's comments")

        api.getMangaComments(mangaId: mangaId, title: mangaTitle) { (response) in
            self.assertCommentListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testChapterComments() throws {
        let chapterId = 867036 // One Punch Man chapter 131
        let api = MDApi()
        let expectation = self.expectation(description: "Load a chapter's comments")

        api.getChapterComments(chapterId: chapterId) { (response) in
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

    func testMangaApi() throws {
        let mangaId = 7139 // One Punch Man
        let api = MDApi()
        let expectation = self.expectation(description: "Fetch a manga's info through the API")

        api.getMangaInfo(mangaId: mangaId) { (response) in
            XCTAssertNil(response.error)
            self.assertMangaIsValid(response.manga)
            self.assertChapterListIsValid(response.manga?.chapters)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testChapterApi() throws {
        let chapterId = 874030 // The Prince Dances
        let api = MDApi()
        let expectation = self.expectation(description: "Fetch a chapter's info through the API")

        api.getChapterInfo(chapterId: chapterId) { (response) in
            XCTAssertNil(response.error)
            self.assertChapterIsValid(response.chapter)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
