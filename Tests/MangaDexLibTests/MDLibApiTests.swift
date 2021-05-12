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
        api.requestHandler.resetSession()
    }

    /// By default, auth information is stored under the `Secret.bundle`, in an `auth.list` file.
    /// See the provided `Secret.example.bundle` to get an idea of how to fill it in
    func getAuthCredentials(in bundle: String, file: String, key: String) -> MDAuthCredentials? {
        let bundleURL = Bundle(for: MDLibApiTests.self).url(forResource: bundle, withExtension: "bundle")
        guard let url = bundleURL?.appendingPathComponent(file),
            let dict = NSDictionary(contentsOf: url),
            let authInfo = dict[key] as? [String: Any] else {
            return nil
        }

        let username = authInfo["username"] as? String
        let password = authInfo["password"] as? String
        return MDAuthCredentials(username: username!, password: password!)

        /*
        let authType = authInfo["type"] as? String
        switch MDAuthCredentials.AuthMode(rawValue: authType!) {
        case .usernamePassword:
            let username = authInfo["username"] as? String
            let password = authInfo["password"] as? String
            return MDAuthCredentials(username: username!, password: password!)
        case .twoFactor:
            let username = authInfo["username"] as? String
            let password = authInfo["password"] as? String
            let code = authInfo["code"] as? String
            return MDAuthCredentials(username: username!, password: password!, twoFactorCode: code!)
        case .token:
            let token = authInfo["token"] as? String
            return MDAuthCredentials(token: token!)
        default:
            return nil
        }
         */
    }

    /// Ping the MangaDex website
    ///
    /// This is useful to perform a fist `GET` request before a `POST` request (e.g. to login) so the CloudFlare and
    /// DDoS-Guard cookies are set
    func ping(api: MDApi) throws {
        let pingExpectation = self.expectation(description: "Ping the MangaDex website")
        var apiError: MDApiError?
        api.ping { (error) in
            apiError = error
            pingExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        guard apiError == nil else {
            throw apiError!
        }

    }

    /// Login the user, for tests requiring an account
    func login(api: MDApi, credentialsKey: String) throws {
        let loginExpectation = self.expectation(description: "Login using username and password")
        let credentials = self.getAuthCredentials(in: "Secret", file: "auth.plist", key: credentialsKey)!
        var apiError: MDApiError?
        api.login(credentials: credentials) { (error) in
            apiError = error
            loginExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Throw instead of using XCTAssertNotNil so this can be caught if the login is expected to fail
        guard apiError == nil else {
            throw apiError!
        }
    }

    func testPing() throws {
        let api = MDApi()
        XCTAssertNoThrow(try ping(api: api))
    }

    func testLoginUsernamePassword() throws {
        let api = MDApi()
        try ping(api: api)
        try login(api: api, credentialsKey: "AuthRegular")
        XCTAssertNotNil(api.sessionJwt)
        XCTAssertNotNil(api.refreshJwt)

        let tokenExpectation = self.expectation(description: "Check that the obtained session token allows auth")
        api.checkToken { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.roles)
            XCTAssert(result?.roles?.contains(MDRole.authenticatedJwt) == true)
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testWrongLogin() throws {
        let api = MDApi()
        try ping(api: api)
        XCTAssertThrowsError(try login(api: api, credentialsKey: "AuthInvalid"))
        XCTAssertNil(api.sessionJwt)
        XCTAssertNil(api.refreshJwt)
    }

    func testLogout() throws {
        let api = MDApi()
        try ping(api: api)
        try login(api: api, credentialsKey: "AuthRegular")
        XCTAssertNotNil(api.sessionJwt)
        XCTAssertNotNil(api.refreshJwt)

        let logoutExpectation = self.expectation(description: "Logout")
        api.logout { (error) in
            XCTAssertNil(error)
            logoutExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNil(api.sessionJwt)
        XCTAssertNil(api.refreshJwt)
    }

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
