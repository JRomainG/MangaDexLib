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

    // swiftlint:disable:next function_body_length
    func testSendAtHomeReport() throws {
        // To send a report, we need to first get a chapter's pages, then download an image, and finally file the report
        let chapterId = "946577a4-d469-45ed-8400-62f03ce4942e" // Solo leveling volume 1 chapter 1 (en)

        // Start by getting information about the chapter
        var chapter: MDChapter?
        let mangaExpectation = self.expectation(description: "Get the chapter's information")
        api.viewChapter(chapterId: chapterId) { (result, _) in
            chapter = result?.object?.data
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Now, find out where the chapter's pages are hosted
        var node: MDAtHomeNode?
        let nodeExpectation = self.expectation(description: "Get the chapter's MD@Home node")
        api.getChapterServer(chapterId: chapterId) { (result, _) in
            node = result
            nodeExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        if node?.baseUrl.absoluteString == MDImageServer.uploads.rawValue {
            throw XCTSkip("The API returned a node which is not part of the MD@Home network")
        }

        // Now get the URLs for the pages
        XCTAssertNotNil(chapter)
        XCTAssertNotNil(node)
        let urls = chapter?.getPageUrls(node: node!, lowRes: false)
        XCTAssertNotNil(urls)
        XCTAssertNotNil(urls?.first)

        // Download the first image of the bunch
        let startTime = DispatchTime.now()
        var report: MDAtHomeReport?
        let pageExpectation = self.expectation(description: "Download the chapter page")
        URLSession.shared.dataTask(with: urls!.first!) { (data, response, error) in
            // First, build the report
            let endTime = DispatchTime.now()
            let duration = Int((endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1000000)

            let res = response as? HTTPURLResponse
            let cacheHeader = res?.allHeaderFields["X-Cache"] as? String ?? ""

            report = MDAtHomeReport(url: urls!.first!,
                                    success: error == nil,
                                    cached: cacheHeader.starts(with: "HIT"),
                                    bytes: data?.count ?? 0,
                                    duration: duration)

            XCTAssertNil(error)
            XCTAssertNotNil(data)
            pageExpectation.fulfill()
        }.resume()
        waitForExpectations(timeout: 15, handler: nil)

        // If the download failed, make sure to still send a report
        if report == nil {
            let endTime = DispatchTime.now()
            let duration = Int((endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1000000)
            report = MDAtHomeReport(url: urls!.first!,
                                    success: false,
                                    cached: false,
                                    bytes: 0,
                                    duration: duration)
        }

        // Finally, send the report
        let reportExpectation = self.expectation(description: "Send an MD@Home report")
        api.sendAtHomeReport(info: report!) { (error) in
            XCTAssertNil(error)
            reportExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetReportReasons() throws {
        let objectType = MDObjectType.manga
        let expectation = self.expectation(description: "Get the list of report reasons")
        api.getReportReasons(objectType: objectType) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.results.count > 0)
            XCTAssertNotNil(result?.results.first)
            XCTAssertNotNil(result?.results.first?.data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetLegacyMapping() throws {
        let query = MDMappingQuery(objectType: .manga, legacyIds: [1]) // Tower of God
        let expectation = self.expectation(description: "Get the mapping")
        api.getLegacyMapping(query: query) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.count, 1)
            XCTAssert(result?.first?.object?.data.newId == "c0ee660b-f9f2-45c3-8068-5123ff53f84a")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testPing() throws {
        XCTAssertNoThrow(try ping(api: api))
    }

}
