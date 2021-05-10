//
//  MDPath+Chapter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 02/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Build the URL to get a list of chapter
    /// - Returns: The MangaDex URL
    static func getChapterList() -> URL {
        return buildUrl(for: .chapter)
    }

    /// Build the URL to search through the list of chapters using the specified filter
    /// - Parameter filter: The filter to use during search
    /// - Returns: The MangaDex URL
    static func searchChapters(filter: MDChapterFilter) -> URL {
        return buildUrl(for: .chapter, with: filter.getParameters())
    }

    /// Build the URL to view the specified chapter's information
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func viewChapter(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId])
    }

    /// Build the URL to update the specified chapter's information
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func updateChapter(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId])
    }

    /// Build the URL to delete the specified chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func deleteChapter(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId])
    }

    /// Build the URL to mark the specified chapter as read for the logged-in user
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func markChapterRead(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId, "read"])
    }

    /// Build the URL to mark the specified chapter as unread for the logged-in user
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func markChapterUnread(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId, "read"])
    }

    /// Build the URL to get a chapter's page images
    /// - Parameter baseURL: The URL of the server to use (see `getAtHomeNodeURL`)
    /// - Parameter chapterHash: The hash of the page to get
    /// - Parameter pageId: The name of the page file to get
    /// - Parameter lowRes: Whether to get the low resolution version of the image or not
    /// - Returns: The MangaDex URL
    ///
    /// This is used to get the URL of the server which will server a chapter's images
    static func getChapterPage(baseURL: URL, chapterHash: String, pageId: String, lowRes: Bool) -> URL {
        let endpoint = lowRes ? "data-saver" : "data"
        return buildUrl(for: baseURL, with: [endpoint, chapterHash, pageId])
    }

}
