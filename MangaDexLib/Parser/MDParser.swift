//
//  MDParser.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

/// The class responsible for parsing HTML / JSON to Swift objects
class MDParser {

    static func parse(html: String) throws -> Document {
        return try SwiftSoup.parse(html)
    }

    static func parse<T>(json: String, type: T.Type) throws -> T where T: Decodable {
        let jsonData = json.data(using: .utf8)!
        return try JSONDecoder().decode(T.self, from: jsonData)
    }

    static func getElements(by className: String, from doc: Document) throws -> Elements {
        return try doc.getElementsByClass(className)
    }

    static func getElement(by elementId: String, from doc: Document) throws -> Element? {
        return try doc.getElementById(elementId)
    }

}

// MARK: - MDParser Homepage Manga List

extension MDParser {

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get a manga's ID
    ///
    /// The format of the element is:
    /// `<div class="manga-entry [...]" data-id="[...]">`
    static let mangaEntryClass = "manga-entry"

    /// The name of the parameter to lookup in an extracted manga entry
    ///
    /// The format of the element is:
    /// `<div class="manga-entry [...]" data-id="[...]">`
    static let mangaEntryIdKey = "data-id"

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get a manga's title and ID
    ///
    /// The format of the element is:
    /// `<a title="[...]" href="/title/[id]/[...]" class="manga_title [...]">[...]</a>`
    static let mangaEntryTitleClass = "manga_title"

    /// Extract the id from the relative link of a manga
    ///
    /// The format is `/title/[id]/[manga-name]`
    private func getIdFromHref(_ href: String) -> Int? {
        let components = href.components(separatedBy: "/")
        guard components.count > 2 else {
            return nil
        }
        return Int(components[2])
    }

    /// Extract the list of mangas present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of mangas IDs
    ///
    /// Only the `title` and `id` are extracted by this method
    func getMangas(from content: String) throws -> [MDManga] {
        let doc = try MDParser.parse(html: content)
        let elements = try MDParser.getElements(by: MDParser.mangaEntryTitleClass, from: doc)

        var mangas: [MDManga] = []
        for element in elements {
            // Extract the info for this element
            let title = try element.text()
            let href = try element.attr("href")

            // To be more robust, ignore mangas for which the extract failed
            // Indeed, sometimes other elements have the same class as what we're looking for
            if let id = self.getIdFromHref(href) {
                mangas.append(MDManga(title: title, id: id))
            }
        }
        return mangas
    }

    /// Extract the list of manga IDs present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of mangas IDs
    ///
    /// This can be used as backup if `getMangas` fails
    func getMangaIds(from content: String) throws -> [MDManga] {
        let doc = try MDParser.parse(html: content)
        let elements = try MDParser.getElements(by: MDParser.mangaEntryClass, from: doc)

        var mangas: [MDManga] = []
        for element in elements {
            let mangaId = try element.attr(MDParser.mangaEntryIdKey)
            mangas.append(MDManga(id: Int(mangaId)!))
        }
        return mangas
    }

}
