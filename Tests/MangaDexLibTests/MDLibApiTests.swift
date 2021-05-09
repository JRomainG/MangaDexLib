//
//  MDLibApiTests.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

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
        api.logout(completion: { (error) in
            XCTAssertNil(error)
            logoutExpectation.fulfill()
        })
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
            XCTAssertNotNil(result!.results.first?.object)
            XCTAssertNotNil(result!.results.first?.object?.data)
            mangaExpectation.fulfill()
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
        api.getRandomManga { (manga, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(manga)
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
