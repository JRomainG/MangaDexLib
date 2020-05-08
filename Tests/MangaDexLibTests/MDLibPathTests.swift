//
//  MDLibPathTests.swift
//  MDLibPathTests
//
//  Created by Jean-Romain on 27/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import XCTest
@testable import MangaDexLib

// swiftlint:disable:next type_body_length
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
        let featuredMangaURL = MDPath.featuredMangas()
        let expectedURL = URL(string: "\(MDApi.baseURL)/featured")!
        assertUrlsAreEqual(featuredMangaURL, expectedURL)
    }

    func testLatestMangasPath() throws {
        let page = 12
        let latestMangaURL = MDPath.latestMangas(page: page)
        let expectedURL = URL(string: "\(MDApi.baseURL)/updates/\(page)")!
        assertUrlsAreEqual(latestMangaURL, expectedURL)
    }

    func testLatestFollowedPath() throws {
        let page = 2
        let type = MDPath.ResourceType.chapters
        let status = MDReadingStatus.reading
        let latestFollowedURL = MDPath.latestFollowed(page: page, type: type, status: status)
        let expectedURL = URL(string: "\(MDApi.baseURL)/follows/\(type.rawValue)/\(status.rawValue)/\(page)")!
        assertUrlsAreEqual(latestFollowedURL, expectedURL)
    }

    func testRandomMangaPath() throws {
        let randomMangaURL = MDPath.randomManga()
        let expectedURL = URL(string: "\(MDApi.baseURL)/manga")!
        assertUrlsAreEqual(randomMangaURL, expectedURL)
    }

    func testHistoryPath() throws {
        let historyURL = MDPath.history()
        let expectedURL = URL(string: "\(MDApi.baseURL)/history")!
        assertUrlsAreEqual(historyURL, expectedURL)
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

    func testMangaDetailsPath() throws {
        let mangaId = 7139
        let mangaTitle = "One Punch Man"
        let mangaNormalizedTitle = "one-punch-man"
        let detailsURL = MDPath.mangaDetails(mangaId: mangaId, mangaTitle: mangaTitle)
        let expectedURL = URL(string: "\(MDApi.baseURL)/title/\(mangaId)/\(mangaNormalizedTitle)")!
        assertUrlsAreEqual(detailsURL, expectedURL)
    }

    func testMangaCommentsPath() throws {
        let mangaId = 7139
        let mangaTitle = "One Punch Man"
        let mangaNormalizedTitle = "one-punch-man"
        let commentsURL = MDPath.mangaComments(mangaId: mangaId, mangaTitle: mangaTitle)
        let expectedURL = URL(string: "\(MDApi.baseURL)/title/\(mangaId)/\(mangaNormalizedTitle)/comments")!
        assertUrlsAreEqual(commentsURL, expectedURL)
    }

    func testMangaChaptersPath() throws {
        let mangaId = 7139
        let page = 4
        let mangaTitle = "One Punch Man"
        let mangaNormalizedTitle = "one-punch-man"
        let commentsURL = MDPath.mangaChapters(mangaId: mangaId, mangaTitle: mangaTitle, page: page)
        let expectedURL = URL(string: "\(MDApi.baseURL)/title/\(mangaId)/\(mangaNormalizedTitle)/chapters/\(page)")!
        assertUrlsAreEqual(commentsURL, expectedURL)
    }

    func testMangaCoverPath() throws {
        let mangaId = 43649
        let coverURL = MDPath.cover(mangaId: mangaId)
        let expectedURL = URL(string: "\(MDApi.baseURL)/images/manga/43649.large.jpg")!
        assertUrlsAreEqual(coverURL, expectedURL)
    }

    func testChapterInfoPath() throws {
        let chapterId = 867036 // One Punch Man chapter 131
        let server = MDServer.naEu1
        let apiURL = MDPath.chapterInfo(chapterId: chapterId, server: server)
        let expected = "\(MDApi.baseURL)/api/?id=\(chapterId)&server=\(server.rawValue)&type=chapter"
        let expectedURL = URL(string: expected)!
        assertUrlsAreEqual(apiURL, expectedURL)
    }

    func testChapterInfoServerPath() throws {
        let chapterId = 810605 // 5Tobun chapter 122
        let server = MDServer.automatic
        let apiURL = MDPath.chapterInfo(chapterId: chapterId, server: server)
        let expectedURL = URL(string: "\(MDApi.baseURL)/api/?id=\(chapterId)&type=chapter")!
        assertUrlsAreEqual(apiURL, expectedURL)
    }

    func testChapterPagePath() throws {
        let server = "https://s5.mangadex.org/data/"
        let hash = "46933c48657c37e93b2e20ee7134085e" // Komi-san One Shot
        let page = "x1.png"
        let imageUrl = MDPath.chapterPage(server: server, hash: hash, page: page)
        let expectedURL = URL(string: "\(server)\(hash)/\(page)")!
        assertUrlsAreEqual(imageUrl, expectedURL)
    }

    func testChapterCommentsPath() throws {
        let chapterId = 7139
        let commentsURL = MDPath.chapterComments(chapterId: chapterId)
        let expectedURL = URL(string: "\(MDApi.baseURL)/chapter/\(chapterId)/comments")!
        assertUrlsAreEqual(commentsURL, expectedURL)
    }

    func testThreadPath() throws {
        let threadId = 237699 // One Punch Man chapter 131
        let page = 6
        let threadURL = MDPath.thread(threadId: threadId, page: page)
        let expectedURL = URL(string: "\(MDApi.baseURL)/thread/\(threadId)/\(page)")!
        assertUrlsAreEqual(threadURL, expectedURL)
    }

    func testGroupPath() throws {
        let groupId = 9293 // Dropped Manga Scans
        let groupURL = MDPath.groupInfo(groupId: groupId)
        let expectedURL = URL(string: "\(MDApi.baseURL)/group/\(groupId)")!
        assertUrlsAreEqual(groupURL, expectedURL)
    }

    func testMdListPath() throws {
        let userId = 3 // ixlone
        let status = MDReadingStatus.all
        let mdListURL = MDPath.mdList(userId: userId, status: status)
        let expectedURL = URL(string: "\(MDApi.baseURL)/list/\(userId)/\(status.rawValue)")!
        assertUrlsAreEqual(mdListURL, expectedURL)
    }

    func testExternalPath() throws {
        let resource = MDResource.mangaUpdates
        let resourceId = "140860" // Buddha Cafe
        let externalURL = MDPath.externalResource(resource: resource, path: resourceId)!
        let expectedURL = URL(string: "\(resource.baseURL!)\(resourceId)")!
        assertUrlsAreEqual(externalURL, expectedURL)
    }

    func testExternalAbsolutePath() throws {
        let resource = MDResource.eBookJapan
        let resourceId = "https://ebookjapan.yahoo.co.jp/books/428086" // Buddha Cafe
        let externalURL = MDPath.externalResource(resource: resource, path: resourceId)!
        let expectedURL = URL(string: resourceId)!
        assertUrlsAreEqual(externalURL, expectedURL)
    }

    func testLoginActionPath() throws {
        let loginURL = MDPath.loginAction()
        let expectedURL = URL(string: "\(MDApi.baseURL)/ajax/actions.ajax.php?function=login")!
        assertUrlsAreEqual(loginURL, expectedURL)
    }

    func testLoginActionNoJsPath() throws {
        let loginURL = MDPath.loginAction(javascriptEnabled: false)
        let expectedURL = URL(string: "\(MDApi.baseURL)/ajax/actions.ajax.php?function=login&nojs=1")!
        assertUrlsAreEqual(loginURL, expectedURL)
    }

    func testReadActionPath() throws {
        let chapterId = 7139
        let readURL = MDPath.readChapterAction(chapterId: chapterId)
        let expected = "\(MDApi.baseURL)/ajax/actions.ajax.php?function=chapter_mark_read&id=\(chapterId)"
        let expectedURL = URL(string: expected)!
        assertUrlsAreEqual(readURL, expectedURL)
    }

    func testUnreadActionPath() throws {
        let chapterId = 7139
        let unreadURL = MDPath.unreadChapterAction(chapterId: chapterId)
        let expected = "\(MDApi.baseURL)/ajax/actions.ajax.php?function=chapter_mark_unread&id=\(chapterId)"
        let expectedURL = URL(string: expected)!
        assertUrlsAreEqual(unreadURL, expectedURL)
    }

    func testFollowActionPath() throws {
        let mangaId = 7139
        let status = MDReadingStatus.planToRead
        let followURL = MDPath.followManga(mangaId: mangaId, status: status)

        var expected = "\(MDApi.baseURL)/ajax/actions.ajax.php?function=manga_follow"
        expected += "&id=\(mangaId)"
        expected += "&type=\(status.rawValue)"
        assertUrlsAreEqual(followURL, URL(string: expected)!)
    }

    func testCommentActionPath() throws {
        let threadId = 237699
        let commentURL = MDPath.comment(threadId: threadId)
        let expected = "\(MDApi.baseURL)/ajax/actions.ajax.php?function=post_reply&id=\(threadId)"
        let expectedURL = URL(string: expected)!
        assertUrlsAreEqual(commentURL, expectedURL)
    }

}
