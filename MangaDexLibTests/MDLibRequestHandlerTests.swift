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

    func testGetRequest() throws {
        let requestHandler = MDRequestHandler()
        let url = URL(string: MDApi.baseURL)!

        let expectation = self.expectation(description: "Load MangaDex homepage")
        requestHandler.get(url: url) { (content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSetCookie() throws {
        let requestHandler = MDRequestHandler()
        let url = URL(string: MDApi.baseURL)!
        let cookieType = MDRequestHandler.CookieType.ratedFilter
        let cookieValue = String(MDRatedFilter.noR18.rawValue)
        requestHandler.setCookie(type: cookieType, value: cookieValue)

        let cookies = requestHandler.cookieJar.cookies(for: url)
        XCTAssertNotNil(cookies)
        XCTAssertEqual(cookies!.filter({ (cookie) -> Bool in
            return cookie.name == cookieType.rawValue && cookie.value == cookieValue
            }).count, 1)
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
        let url = URL(string: "http://whatsmyuseragent.org")!
        let userAgent = MDApi.defaultUserAgent + "Test"
        requestHandler.setUserAgent(userAgent)

        let expectation = self.expectation(description: "Fetch User Agent")
        requestHandler.get(url: url) { (content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)
            XCTAssert(content!.contains(userAgent))
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
}
