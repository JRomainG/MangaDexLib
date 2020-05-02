//
//  MDParser+ChapterList.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 30/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get a chapter's info
    ///
    /// The format of the element is:
    /// `<div class="chapter-row [...]">`
    static private let chapterEntryClass = "chapter-row"

    /// Mapping between the html attributes and the keys used by the json API
    ///
    /// Under the hood, the html data is converted to json, and then the JSON is
    /// directly parsed using Apple's API to build the `MDChapter` struct
    static private let chapterAttributes: [String: MDChapter.CodingKeys] = [
        "data-id": .chapterId,
        "data-manga-id": .mangaId,
        "data-title": .title,
        "data-volume": .volume,
        "data-read": .read,
        "data-lang": .originalLang,
        "data-group": .groupId,
        "data-timestamp": .timestamp,
        "data-comments": .nbrComments
    ]

    /// Return a json `Data` object representing the given `Element`
    /// - Parameter element: An `Element` containing information about a chapter
    private func buildJson(from element: Element) throws -> Data {
        var dict: [String: Any] = [:]
        for (attr, key) in MDParser.chapterAttributes {
            let value = try element.attr(attr)
            let parsedValue = MDChapter.decodeValue(value, for: key)
            dict[key.rawValue] = parsedValue
        }
        return try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
    }

    /// Extract the list of chapters present in the given html string
    /// - Parameter content: The html string to parse
    /// - Returns: A list of `MDChapter` instances
    func getChapters(from content: String) throws -> [MDChapter] {
        let doc = try MDParser.parse(html: content)
        let elements = try doc.getElementsByClass(MDParser.chapterEntryClass)

        var chapters: [MDChapter] = []
        for element in elements {
            do {
                // Get the json representing this element
                let jsonData = try buildJson(from: element)
                guard let jsonString = String(bytes: jsonData, encoding: .utf8) else {
                    continue
                }
                // Parse the json and append it if it has an id
                let chapter = try MDParser.parse(json: jsonString, type: MDChapter.self)
                guard chapter.chapterId != nil else {
                    continue
                }
                chapters.append(chapter)
            } catch {
                print(error)
                continue
            }
        }
        return chapters
    }

}
