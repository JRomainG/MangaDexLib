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
    ///
    /// The format of the element is:
    /// `<div class="manga-entry [...]" data-id="[...]">`
    static let mangaEntryClass = "manga-entry"

    /// The name of the parameter to lookup in an extracted manga entry
    ///
    /// The format of the element is:
    /// `<div class="manga-entry [...]" data-id="[...]">`
    static let mangaEntryIdKey = "data-id"

    /// Extract the list of mangas present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of mangas IDs
    func getMangaIds(from content: String) throws -> [Int] {
        let doc = try MDParser.parse(html: content)
        let elements = try MDParser.getElements(by: MDParser.mangaEntryClass, from: doc)

        var mangaIds: [Int] = []
        for element in elements {
            let mangaId = try element.attr(MDParser.mangaEntryIdKey)
            mangaIds.append(Int(mangaId)!)
        }
        return mangaIds
    }

}
