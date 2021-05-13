//
//  MDLibApiTests+Infra.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testGetChapterServer() throws {
        let chapterId = "946577a4-d469-45ed-8400-62f03ce4942e" // Solo leveling volume 1 chapter 1 (en)
        let expectation = self.expectation(description: "Get the chapter's MD@Home node")
        api.getChapterServer(chapterId: chapterId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testPing() throws {
        XCTAssertNoThrow(try ping(api: api))
    }

}
