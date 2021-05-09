//
//  MDLibRequestHandlerTests.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import XCTest
@testable import MangaDexLib

class MDLibRequestHandlerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Parse a given json string to an abstract NSDictionary
    func parseJson(from string: String?) -> NSDictionary? {
        do {
            let jsonData = string?.data(using: .utf8)
            let decoded = try JSONSerialization.jsonObject(with: jsonData!, options: [])
            return decoded as? NSDictionary
        } catch {
            return nil
        }
    }

    /// Convenience method to perform a GET request
    func get(url: URL,
             requestHandler: MDRequestHandler = MDRequestHandler(),
             completion: MDRequestHandler.RequestCompletion?) {
        let expectation = self.expectation(description: "Load \(url.absoluteString)")
        requestHandler.get(url: url) { (response, content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)
            XCTAssertEqual(response?.statusCode, 200)
            completion?(response, content, error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetRequest() throws {
        let url = URL(string: "https://httpbin.org/get?key=value")!
        get(url: url) { (_, content, _) in
            let dict = self.parseJson(from: content)
            let args = dict?["args"] as? [String: String]
            let value = args?["key"]
            XCTAssert(value == "value")
        }
    }

    func testPostRequest() {
        let requestHandler = MDRequestHandler()
        requestHandler.setCookie(type: .ddosGuard1, value: "not_empty")
        let body = ["username": "user", "password": "pass"]
        let url = URL(string: "https://httpbin.org/post")!
        let expectation = self.expectation(description: "Load httpbin's POST test page")

        requestHandler.post(url: url, content: body) { (http, content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)
            XCTAssertEqual(http?.statusCode, 200)

            let dict = self.parseJson(from: content)
            let args = dict?["json"] as? [String: String]
            for (key, value) in body {
                XCTAssert(args?[key] == "\(value)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testPutRequest() {
        let requestHandler = MDRequestHandler()
        requestHandler.setCookie(type: .ddosGuard1, value: "not_empty")
        let body = ["username": "user", "password": "pass"]
        let url = URL(string: "https://httpbin.org/put")!
        let expectation = self.expectation(description: "Load httpbin's PUT test page")

        requestHandler.put(url: url, content: body) { (http, content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)
            XCTAssertEqual(http?.statusCode, 200)

            let dict = self.parseJson(from: content)
            let args = dict?["json"] as? [String: String]
            for (key, value) in body {
                XCTAssert(args?[key] == "\(value)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testDeleteRequest() {
        let requestHandler = MDRequestHandler()
        requestHandler.setCookie(type: .ddosGuard1, value: "not_empty")
        let url = URL(string: "https://httpbin.org/delete")!
        let expectation = self.expectation(description: "Load httpbin's DELETE test page")

        requestHandler.delete(url: url) { (http, content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)
            XCTAssertEqual(http?.statusCode, 200)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testGetSetCookie() throws {
        let requestHandler = MDRequestHandler()
        let cookieType = MDRequestHandler.CookieType.authToken
        let cookieValue = "myauthtoken"
        requestHandler.setCookie(type: cookieType, value: cookieValue)

        let retreivedCookie = requestHandler.getCookie(type: cookieType)
        XCTAssert(retreivedCookie == cookieValue)
    }

    func testResetSession() throws {
        let requestHandler = MDRequestHandler()
        var url = URL(string: "https://httpbin.org/cookies/set?key=value")!

        // Ask the website to set a cookie
        get(url: url, requestHandler: requestHandler) { (_, content, _) in
            let dict = self.parseJson(from: content)
            let cookies = dict?["cookies"] as? [String: String]
            let value = cookies?["key"]
            XCTAssert(value == "value")
        }

        // Reset the session and check that the cookie is not longer set
        requestHandler.resetSession()
        url = URL(string: "https://httpbin.org/cookies")!
        get(url: url, requestHandler: requestHandler) { (_, content, _) in
            let dict = self.parseJson(from: content)
            let cookies = dict?["cookies"] as? [String: String]
            XCTAssert(cookies?.count == 0)
        }
    }

    func testDefaultUserAgent() throws {
        let url = URL(string: "https://httpbin.org/user-agent")!
        get(url: url) { (_, content, _) in
            let dict = self.parseJson(from: content)
            let fetchedUserAgent = dict?["user-agent"] as? String
            XCTAssert(fetchedUserAgent != MDApi.defaultUserAgent)
        }
    }

    func testSetUserAgent() throws {
        let requestHandler = MDRequestHandler()
        let url = URL(string: "https://httpbin.org/user-agent")!
        let userAgent = MDApi.defaultUserAgent + "Test"
        requestHandler.setUserAgent(userAgent)

        get(url: url, requestHandler: requestHandler) { (_, content, _) in
            let dict = self.parseJson(from: content)
            let fetchedUserAgent = dict?["user-agent"] as? String
            XCTAssert(fetchedUserAgent == userAgent)
        }
    }

}
