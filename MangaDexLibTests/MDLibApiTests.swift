//
//  MDLibApiTests.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

// swiftlint:disable type_body_length
// swiftlint:disable file_length
class MDLibApiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let api = MDApi()
        let expectation = self.expectation(description: "Logout after completing test")
        api.logout { (_) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    /// By default, auth information is stored under the `Secret.bundle`, in an `auth.list` file.
    /// See the provided `Secret.example.bundle` to get an idea of how to fill it in
    func getAuth(in bundle: String, file: String, key: String) -> MDAuth? {
        let bundleURL = Bundle(for: MDLibApiTests.self).url(forResource: bundle, withExtension: "bundle")
        guard let url = bundleURL?.appendingPathComponent(file),
            let dict = NSDictionary(contentsOf: url),
            let authInfo = dict[key] as? [String: Any] else {
            return nil
        }

        let authType = authInfo["type"] as? String
        switch MDAuth.AuthType(rawValue: authType!) {
        case .regular:
            let username = authInfo["username"] as? String
            let password = authInfo["password"] as? String
            let remember = authInfo["remember"] as? Bool
            return MDAuth(username: username!, password: password!, remember: remember!)
        case .twoFactor:
            let username = authInfo["username"] as? String
            let password = authInfo["password"] as? String
            let code = authInfo["code"] as? String
            let remember = authInfo["remember"] as? Bool
            return MDAuth(username: username!, password: password!, code: code!, remember: remember!)
        case .token:
            let token = authInfo["token"] as? String
            return MDAuth(token: token!)
        default:
            return nil
        }
    }

    /// Login the user, for tests requiring an account
    func login(api: MDApi) {
        let loginExpectation = self.expectation(description: "Login using username and password")
        if !api.isLoggedIn() {
            let auth = self.getAuth(in: "Secret", file: "auth.plist", key: "AuthRegular")!
            api.login(with: auth) { (_) in
                loginExpectation.fulfill()
            }
        } else {
            loginExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssert(api.isLoggedIn())
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

    func assertChapterListIsValid(for response: MDResponse) {
        XCTAssert(response.type == .chapterList)
        XCTAssertNil(response.error)
        XCTAssertNotNil(response.rawValue)
        assertChapterListIsValid(response.chapters)
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
        XCTAssertNotNil(chapter?.groupId)
        XCTAssertNotNil(chapter?.getOriginalLang())
    }

    func assertGroupIsValid(_ group: MDGroup?) {
        XCTAssertNotNil(group)
        XCTAssertNotNil(group?.groupId)
        XCTAssertNotNil(group?.name)
        XCTAssertNotNil(group?.leader)
        XCTAssertNotNil(group?.members)
        XCTAssert(group!.members!.count > 0)
        XCTAssertNotNil(group?.coverUrl)
        XCTAssertNotNil(group?.links)
    }

    func testGetHomepage() throws {
        let api = MDApi()
        let expectation = self.expectation(description: "Load MangaDex's homepage")

        api.getHomepage { (response) in
            XCTAssert(response.type == .homepage)
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.rawValue)
            XCTAssertNotNil(response.announcement)
            XCTAssertNotNil(response.announcement?.body)
            XCTAssertNotNil(response.announcement?.textBody)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
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

    func testFollowedMangas() throws {
        let page = 2
        let status = MDReadingStatus.all
        let api = MDApi()

        // Must be logged-in to follow mangas
        login(api: api)

        let expectation = self.expectation(description: "Load MangaDex last updated mangas page")
        api.getLatestFollowedMangas(page: page, status: status) { (response) in
            self.assertMangaListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testFollowedChapters() throws {
        let page = 2
        let status = MDReadingStatus.all
        let api = MDApi()

        // Must be logged-in to follow mangas
        login(api: api)

        let expectation = self.expectation(description: "Load MangaDex last updated chapters page")
        api.getLatestFollowedChapters(page: page, status: status) { (response) in
            self.assertChapterListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testMangaSearch() throws {
        let api = MDApi()
        let search = MDSearch(title: "Tower of God")

        // Searching requires login
        login(api: api)

        let expectation = self.expectation(description: "Load MangaDex search page")
        api.performSearch(search) { (response) in
            self.assertMangaListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testRandomManga() throws {
        let api = MDApi()
        let expectation = self.expectation(description: "Load random manga page")

        api.getRandomManga { (response) in
            XCTAssert(response.type == .mangaInfo)
            self.assertMangaIsValid(response.manga)
            XCTAssertNotNil(response.manga?.title)
            XCTAssertNotNil(response.manga?.coverUrl)
            XCTAssertNotNil(response.manga?.description)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testHistory() throws {
        let api = MDApi()

        // Must be logged-in to see history
        login(api: api)

        let expectation = self.expectation(description: "Load the user's history manga page")
        api.getHistory { (response) in
            self.assertMangaListIsValid(for: response)
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

    func testMangaChapters() throws {
        let mangaId = 7139
        let page = 2
        let mangaTitle = "One Punch Man"
        let api = MDApi()

        let expectation = self.expectation(description: "Load a manga's chapter list")
        api.getMangaChapters(mangaId: mangaId, title: mangaTitle, page: page) { (response) in
            self.assertChapterListIsValid(for: response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testMangaDetails() throws {
        let mangaId = 7139
        let mangaTitle = "One Punch Man"
        let api = MDApi()

        let expectation = self.expectation(description: "Fetch a manga's details page")
        api.getMangaDetails(mangaId: mangaId, title: mangaTitle) { (response) in
            XCTAssertNil(response.error)
            self.assertMangaIsValid(response.manga)
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

    func testGroupInfo() throws {
        let groupId = 9293 // Dropped Manga Scans
        let api = MDApi()
        let expectation = self.expectation(description: "Fetch a group's info")

        api.getGroupInfo(groupId: groupId) { (response) in
            XCTAssertNil(response.error)
            self.assertGroupIsValid(response.group)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testMdList() throws {
        let userId = 3 // ixlone
        let status = MDReadingStatus.all
        let api = MDApi()
        let expectation = self.expectation(description: "Fetch a user's MDList")

        api.getMdList(userId: userId, status: status) { (response) in
            self.assertMangaListIsValid(for: response)
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
            XCTAssertNotNil(response.chapter?.getPageUrls())
            XCTAssertGreaterThan(response.chapter!.getPageUrls()!.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testRegularLogin() throws {
        let auth = getAuth(in: "Secret", file: "auth.plist", key: "AuthRegular")!
        let api = MDApi()

        // Make sure we're logged out
        let logoutExpectation = self.expectation(description: "Logout")
        api.logout { (_) in
            logoutExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertFalse(api.isLoggedIn())

        let loginExpectation = self.expectation(description: "Login using username and password")
        api.login(with: auth) { (response) in
            XCTAssert(api.isLoggedIn())
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.token)
            loginExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testTwoFactorLogin() throws {
        let auth = getAuth(in: "Secret", file: "auth.plist", key: "Auth2FA")!
        let api = MDApi()

        // Make sure we're logged out
        let logoutExpectation = self.expectation(description: "Logout")
        api.logout { (_) in
            logoutExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertFalse(api.isLoggedIn())

        let loginExpectation = self.expectation(description: "Login using two factor authentication")
        api.login(with: auth) { (response) in
            XCTAssert(api.isLoggedIn())
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.token)
            loginExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testLogout() throws {
        let api = MDApi()

        // Make sure we're logged in
        login(api: api)
        XCTAssert(api.isLoggedIn())

        let logoutExpectation = self.expectation(description: "Logout")
        api.logout { (response) in
            XCTAssertFalse(api.isLoggedIn())
            XCTAssertNil(response.error)
            logoutExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
