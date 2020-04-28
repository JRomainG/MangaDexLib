//
//  MDLibParserTests.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import XCTest
@testable import MangaDexLib

class MDLibParserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginCheck() throws {
        let url = URL(string: "\(MDApi.baseURL)/search?title=title")!
        let requestHandler = MDRequestHandler()
        let parser = MDParser()
        let expectation = self.expectation(description: "Load MangaDex's search page")

        requestHandler.get(url: url) { (content, _) in
            var isLogin = false
            do {
                let doc = try MDParser.parse(html: content!)
                isLogin = parser.isLoginPage(document: doc)
            } catch {
            }

            XCTAssertTrue(isLogin)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
