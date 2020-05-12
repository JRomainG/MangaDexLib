//
//  MDParser+MangaList.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get a manga's ID
    ///
    /// The format of the element is:
    /// `<div class="manga-entry [...]" data-id="[...]">`
    static private let mangaEntryClass = "manga-entry"

    /// The name of the parameter to lookup in an extracted manga entry to get
    /// the manga's ID
    ///
    /// The format of the element is:
    /// `<div class="manga-entry [...]" data-id="[...]">`
    static private let mangaEntryIdKey = "data-id"

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get the manga's title and ID
    ///
    /// The format of the element is:
    /// `<a title="[...]" href="/title/[id]/[...]" class="manga_title [...]">[...]</a>`
    static private let mangaEntryTitleClass = "manga_title"

    /// The selector to lookup in the manga entry to find the connected user's reading status
    static private let mangaEntryReadingStatusButtonSelector = ".btn-group"

    /// Extract the list of mangas present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of `MDManga` instances
    ///
    /// - Note: The `title`, `coverUrl`, `mangaId`  and `readingStatus` are extracted by this method
    func getMangas(from content: String) throws -> [MDManga] {
        let doc = try MDParser.parse(html: content)
        let elements = try doc.getElementsByClass(MDParser.mangaEntryTitleClass)

        var mangas: [MDManga] = []
        for element in elements {
            // Extract the info for this element
            let title = try element.text()
            let href = try element.attr("href")

            // To be more robust, ignore mangas for which the extract failed
            // Indeed, sometimes other elements have the same class as what we're looking for
            if let mangaId = self.getIdFromHref(href) {
                var manga = MDManga(title: title, mangaId: mangaId)
                mangas.append(manga)
            }
        }
        return mangas
    }

    /// Extract the list of manga IDs present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of `MDManga` instances
    ///
    /// This serves as backup if `getMangas` fails
    /// - Note: Only the `mangaId` is extracted by this method
    func getMangaIds(from content: String) throws -> [MDManga] {
        let doc = try MDParser.parse(html: content)
        let elements = try doc.getElementsByClass(MDParser.mangaEntryClass)

        var mangas: [MDManga] = []
        for element in elements {
            let mangaIdString = try element.attr(MDParser.mangaEntryIdKey)

            if let mangaId = Int(mangaIdString) {
                mangas.append(MDManga(mangaId: mangaId))
            }
        }
        return mangas
    }

}
