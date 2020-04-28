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

    func testGetRequest() throws {
        let api = MDApi()
        let expectation = self.expectation(description: "Load MangaDex homepage")
        api.getHomepage { (content, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(content)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
