//
//  MDLibApiTests+Auth.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

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

}
