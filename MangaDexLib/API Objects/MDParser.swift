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

// MARK: - MDParser Common Manga Methods

extension MDParser {

    /// Split an absolute of relative URL's path in a normalized way
    private func splitUrlPath(_ href: String) -> [String] {
        // If this is an absolute URL, only keep the path
        var path = href

        if let url = URL(string: href) {
            path = url.path
        }

        // Remove the leading "/" if there is one
        if path.hasPrefix("/") {
            path.remove(at: path.startIndex)
        }

        return path.components(separatedBy: "/")
    }

    /// Extract the id from the link to a manga
    ///
    /// The format is `/title/[id]/[manga-name]`, absolute and relative URLs are handled
    private func getIdFromHref(_ href: String) -> Int? {
        let components = splitUrlPath(href)
        guard components.count >= 2 else {
            return nil
        }
        return Int(components[1])
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
            let mangaIdString = try element.attr(MDParser.mangaEntryIdKey)

            if let mangaId = Int(mangaIdString) {
                mangas.append(MDManga(id: mangaId))
            }
        }
        return mangas
    }

}

// MARK: - MDParser Manga Page

extension MDParser {

    /// Extract a manga's info from a manga detail html page
    /// - Parameter content: The html string to parse
    /// - Returns: The extracted manga
    func getMangaInfo(from content: String) throws -> MDManga {
        let doc = try MDParser.parse(html: content)

        // Extra the meta tags, as it's way easier
        var elements = try doc.select("head > meta[property=og:title]")
        let title = try elements.get(0).attr("content").replacingOccurrences(of: " (Title) - MangaDex", with: "")

        elements = try doc.select("head > meta[property=og:description]")
        let description = try elements.get(0).attr("content")

        elements = try doc.select("head > meta[property=og:image]")
        let coverUrl = try elements.get(0).attr("content")

        elements = try doc.select("head > link[rel=canonical]")
        let href = try elements.get(0).attr("href")
        let mangaId = getIdFromHref(href)!

        var manga = MDManga(title: title, id: mangaId)
        manga.description = description
        manga.coverUrl = coverUrl
        return manga
    }

}
