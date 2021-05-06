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
    public static func getChapterList() -> URL {
        return buildUrl(for: .chapter)
    }

    /// Build the URL to view the specified chapter's information
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    public static func viewChapter(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId])
    }

    /// Build the URL to update the specified chapter's information
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    public static func updateChapter(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId])
    }

    /// Build the URL to delete the specified chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    public static func deleteChapter(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId])
    }

    /// Build the URL to mark the specified chapter as read for the logged-in user
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    public static func markChapterRead(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId, "read"])
    }

    /// Build the URL to mark the specified chapter as unread for the logged-in user
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    public static func markChapterUnread(chapterId: String) -> URL {
        return buildUrl(for: .chapter, with: [chapterId, "read"])
    }

}
