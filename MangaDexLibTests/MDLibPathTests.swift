//
//  MDLibPathTests.swift
//  MDLibPathTests
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import XCTest
@testable import MangaDexLib

class MDLibPathTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Handle checks for URL equality, regardless of the order of get params in the URL
    func assertUrlsAreEqual(_ first: URL, _ second: URL) {
        let firstComponents = URLComponents(string: first.absoluteString)!
        let secondComponents = URLComponents(string: second.absoluteString)!

        if let firstItems = firstComponents.queryItems,
            let secondItems = secondComponents.queryItems {
            // Check that both urls' GET parameters are equal by using double inclusion
            for item in firstItems {
                XCTAssert(secondItems.contains(item))
            }
            for item in secondItems {
                XCTAssert(firstItems.contains(item))
            }

            // Check the path is also correct
            XCTAssert(first.pathComponents == second.pathComponents)
        } else {
            // Since there are not query items, just check the absolute URLs are equal
            XCTAssert(first.absoluteString == second.absoluteString)
        }

    }

    func testListedMangasPath() throws {
        let page = 3
        let popularMangaURL = MDPath.listedMangas(page: page, sort: .bestRating)
        let expectedURL = URL(string: "\(MDApi.baseURL)/titles/\(MDSortOrder.bestRating.rawValue)/\(page)")!
        assertUrlsAreEqual(popularMangaURL, expectedURL)
    }

    func testFeaturedMangasPath() throws {
        let page = 6
        let featuredMangaURL = MDPath.featuredMangas(page: page)
        let expectedURL = URL(string: "\(MDApi.baseURL)/featured/\(page)")!
        assertUrlsAreEqual(featuredMangaURL, expectedURL)
    }

    func testLatestMangasPath() throws {
        let page = 12
        let latestMangaURL = MDPath.latestMangas(page: page)
        let expectedURL = URL(string: "\(MDApi.baseURL)/updates/\(page)")!
        assertUrlsAreEqual(latestMangaURL, expectedURL)
    }

    func testRandomMangaPath() throws {
        let randomMangaURL = MDPath.randomManga()
        let expectedURL = URL(string: "\(MDApi.baseURL)/manga")!
        assertUrlsAreEqual(randomMangaURL, expectedURL)
    }

    func testEncodedSearchMangaPath() throws {
        let search = MDSearch(title: "search title",
                              author: "Firstname Lastname",
                              artist: "あrtist+名前",
                              originalLanguage: .japanese,
                              demographics: [.shounen, .shoujo],
                              publicationStatuses: [.ongoing, .completed],
                              includeTags: [MDFormat.oneShot.rawValue],
                              excludeTags: [MDContent.sexualViolence.rawValue, MDGenre.crime.rawValue],
                              includeTagsMode: .all,
                              excludeTagsMode: .any)

        let searchURL = MDPath.search(search)

        // Manually build what the string should look like
        // swiftlint:disable line_length
        var expected = "\(MDApi.baseURL)/search"
        expected += "?title=\(search.title?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        expected += "&author=\(search.author?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        expected += "&artist=\(search.artist?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        expected += "&lang_id=\(search.originalLanguage!.rawValue)"
        expected += "&demos=\(search.demographics.first!.rawValue),\(search.demographics.last!.rawValue)"
        expected += "&statuses=\(search.publicationStatuses.first!.rawValue),\(search.publicationStatuses.last!.rawValue)"
        expected += "&tags=\(search.includeTags.first!),-\(search.excludeTags.first!),-\(search.excludeTags.last!)"
        expected += "&tag_mode_inc=\(search.includeTagsMode.rawValue)"
        expected += "&tag_mode_exc=\(search.excludeTagsMode.rawValue)"
        expected = expected.replacingOccurrences(of: "+", with: "%2B")
        // swiftlint:enable line_length

        let expectedURL = URL(string: expected)!
        assertUrlsAreEqual(searchURL, expectedURL)
    }

    func testNilSearchMangaPath() throws {
        let search = MDSearch(title: nil,
                              author: nil,
                              artist: nil,
                              originalLanguage: nil,
                              demographics: [],
                              publicationStatuses: [],
                              includeTags: [],
                              excludeTags: [],
                              includeTagsMode: .all,
                              excludeTagsMode: .any)

        let searchURL = MDPath.search(search)

        // Manually build what the string should look like
        var expected = "\(MDApi.baseURL)/search"
        expected += "?tag_mode_inc=\(search.includeTagsMode.rawValue)"
        expected += "&tag_mode_exc=\(search.excludeTagsMode.rawValue)"

        let expectedURL = URL(string: expected)!
        assertUrlsAreEqual(searchURL, expectedURL)
    }

    func testMangaInfoPath() throws {
        let mangaId = 7139 // One Punch Man
        let apiURL = MDPath.mangaInfo(mangaId: mangaId)
        let expectedURL = URL(string: "\(MDApi.baseURL)/api/?id=\(mangaId)&type=manga")!
        assertUrlsAreEqual(apiURL, expectedURL)
    }

    func testChapterInfoPath() throws {
        let chapterId = 867036 // One Punch Man chapter 131
        let server = MDApi.Server.naEu1
        let apiURL = MDPath.chapterInfo(chapterId: chapterId, server: server)
        let expected = "\(MDApi.baseURL)/api/?id=\(chapterId)&server=\(server.rawValue)&type=chapter"
        let expectedURL = URL(string: expected)!
        assertUrlsAreEqual(apiURL, expectedURL)
    }

    func testChapterInfoServerPath() throws {
        let chapterId = 810605 // 5Tobun chapter 122
        let server = MDApi.Server.automatic
        let apiURL = MDPath.chapterInfo(chapterId: chapterId, server: server)
        let expectedURL = URL(string: "\(MDApi.baseURL)/api/?id=\(chapterId)&type=chapter")!
        assertUrlsAreEqual(apiURL, expectedURL)
    }

    func testExternalPath() throws {
        let resource = MDPath.ExternalResource.mangaUpdates
        let resourceId = "140860" // Buddha Cafe
        let externalURL = MDPath.externalResource(resource: resource, path: resourceId)!
        let expectedURL = URL(string: "\(resource.rawValue)\(resourceId)")!
        assertUrlsAreEqual(externalURL, expectedURL)
    }

    func testExternalAbsolutePath() throws {
        let resource = MDPath.ExternalResource.eBookJapan
        let resourceId = "https://ebookjapan.yahoo.co.jp/books/428086" // Buddha Cafe
        let externalURL = MDPath.externalResource(resource: resource, path: resourceId)!
        let expectedURL = URL(string: resourceId)!
        assertUrlsAreEqual(externalURL, expectedURL)
    }

}
