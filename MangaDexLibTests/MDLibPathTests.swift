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

    func testListedMangasPath() throws {
        let page = 3
        let popularMangaURL = MDPath.listedMangas(page: page, sort: .bestRating)
        let expectedURL = URL(string: "\(MDApi.baseURL)/titles/\(SortOrder.bestRating.rawValue)/\(page)")!
        XCTAssert(popularMangaURL.absoluteString == expectedURL.absoluteString)
    }

    func testFeaturedMangasPath() throws {
        let page = 6
        let featuredMangaURL = MDPath.featuredMangas(page: page)
        let expectedURL = URL(string: "\(MDApi.baseURL)/featured/\(page)")!
        XCTAssert(featuredMangaURL.absoluteString == expectedURL.absoluteString)
    }

    func testLatestMangasPath() throws {
        let page = 12
        let latestMangaURL = MDPath.latestMangas(page: page)
        let expectedURL = URL(string: "\(MDApi.baseURL)/updates/\(page)")!
        XCTAssert(latestMangaURL.absoluteString == expectedURL.absoluteString)
    }

    func testRandomMangaPath() throws {
        let latestMangaURL = MDPath.randomManga()
        let expectedURL = URL(string: "\(MDApi.baseURL)/manga")!
        XCTAssert(latestMangaURL.absoluteString == expectedURL.absoluteString)
    }

    func testEncodedSearchMangaPath() throws {
        let search = MDSearch(title: "search title",
                              author: "Firstname Lastname",
                              artist: "あrtist+名前",
                              originalLanguage: .japanese,
                              demographics: [.shounen, .shoujo],
                              publicationStatuses: [.ongoing, .completed],
                              includeTags: [MDSearch.Format.oneShot.rawValue],
                              excludeTags: [MDSearch.Content.sexualViolence.rawValue, MDSearch.Genre.crime.rawValue],
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

        let components = URLComponents(string: searchURL.absoluteString)!
        let expectedComponents = URLComponents(string: expected)!

        // Check that both urls' GET parameters are equal by using double inclusion
        for item in components.queryItems! {
            XCTAssert(expectedComponents.queryItems!.contains(item))
        }

        for item in expectedComponents.queryItems! {
            XCTAssert(components.queryItems!.contains(item))
        }

        // Check the path is also correct
        XCTAssert(components.url?.pathComponents == expectedComponents.url?.pathComponents)
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

        let components = URLComponents(string: searchURL.absoluteString)!
        let expectedComponents = URLComponents(string: expected)!

        // Check that both urls' GET parameters are equal by using double inclusion
        for item in components.queryItems! {
            XCTAssert(expectedComponents.queryItems!.contains(item))
        }

        for item in expectedComponents.queryItems! {
            XCTAssert(components.queryItems!.contains(item))
        }

        // Check the path is also correct
        XCTAssert(components.url?.pathComponents == expectedComponents.url?.pathComponents)
    }

}
