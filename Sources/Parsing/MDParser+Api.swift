//
//  MDParser+Api.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// Parse MangaDex's API's response to a "manga" request
    /// - Parameter json: The json string to parse
    /// - Parameter mangaId: The ID of the manga this json belongs to
    /// - Returns: The parsed manga
    func getMangaApiInfo(from json: String, mangaId: Int) throws -> MDManga? {
        // The MDApiManga object should reflect exactly what is stored in the json
        var apiManga = try MDParser.parse(json: json, type: MDApiManga.self)

        // The description may have some html-encoded content
        if let description = apiManga.manga.description {
            apiManga.manga.description = try Entities.unescape(description)
        }

        // The IDs of the manga and the chapters aren't parsed correctly, so fix this
        apiManga.manga.mangaId = mangaId
        apiManga.manga.status = apiManga.status
        apiManga.manga.chapters = []

        for (chapterId, chapter) in apiManga.chapters {
            var newChapter = chapter
            newChapter.chapterId = chapterId
            newChapter.mangaId = mangaId
            apiManga.manga.chapters?.append(newChapter)
        }

        return apiManga.manga
    }

    /// Parse MangaDex's API's response to a "chapter" request
    /// - Parameter json: The json string to parse
    /// - Returns: The parsed chapter
    func getChapterApiInfo(from json: String) throws -> MDChapter? {
        // Apple's library should be able to do everything by itself
        return try MDParser.parse(json: json, type: MDChapter.self)
    }

}
