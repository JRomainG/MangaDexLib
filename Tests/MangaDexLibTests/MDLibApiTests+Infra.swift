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

    func testPing() throws {
        XCTAssertNoThrow(try ping(api: api))
    }

}
