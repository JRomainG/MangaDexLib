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

    func parseJson(from string: String?) -> NSDictionary? {
        do {
            let jsonData = string?.data(using: .utf8)
            let decoded = try JSONSerialization.jsonObject(with: jsonData!, options: [])
            return decoded as? NSDictionary
        } catch {
            return nil
        }
    }

    func testPostRequest(with encoding: MDRequestHandler.BodyEncoding) {
        let requestHandler = MDRequestHandler()
        let body: [String: LosslessStringConvertible] = ["key": "value", "works": 1]
        let url = URL(string: "https://httpbin.org/post")!
        let expectation = self.expectation(description: "Load httpbin's POST test page")

        requestHandler.post(url: url, content: body, encoding: encoding) { (content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)

            let dict = self.parseJson(from: content)
            let args = dict?["form"] as? [String: String]
            for (key, value) in body {
                XCTAssert(args?[key] == "\(value)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testGetRequest() throws {
        let requestHandler = MDRequestHandler()
        let url = URL(string: "https://httpbin.org/get?key=value")!
        let expectation = self.expectation(description: "Load httpbin's GET test page")

        requestHandler.get(url: url) { (content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)

            let dict = self.parseJson(from: content)
            let args = dict?["args"] as? [String: String]
            let value = args?["key"]
            XCTAssert(value == "value")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testMultipartPostRequest() throws {
        testPostRequest(with: .multipart)
    }

    func testUrlEncodedPostRequest() throws {
        testPostRequest(with: .urlencoded)
    }

    func testGetSetCookie() throws {
        let requestHandler = MDRequestHandler()
        let cookieType = MDRequestHandler.CookieType.ratedFilter
        let cookieValue = String(MDRatedFilter.noR18.rawValue)
        requestHandler.setCookie(type: cookieType, value: cookieValue)

        let retreivedCookie = requestHandler.getCookie(type: cookieType)
        XCTAssert(retreivedCookie == cookieValue)
    }

    func testResetSession() throws {
        let requestHandler = MDRequestHandler()
        requestHandler.setCookie(type: .ratedFilter, value: "AnyValue")
        XCTAssertNotNil(requestHandler.cookieJar.cookies)
        XCTAssertGreaterThan(requestHandler.cookieJar.cookies!.count, 0)

        requestHandler.resetSession()
        XCTAssertNotNil(requestHandler.cookieJar.cookies)
        XCTAssertEqual(requestHandler.cookieJar.cookies!.count, 0)
    }

    func testSetUserAgent() throws {
        let requestHandler = MDRequestHandler()
        let url = URL(string: "https://httpbin.org/user-agent")!
        let userAgent = MDApi.defaultUserAgent + "Test"
        requestHandler.setUserAgent(userAgent)

        let expectation = self.expectation(description: "Fetch User Agent")
        requestHandler.get(url: url) { (content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)

            let dict = self.parseJson(from: content)
            let fetchedUserAgent = dict?["user-agent"] as? String
            XCTAssert(fetchedUserAgent == userAgent)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
