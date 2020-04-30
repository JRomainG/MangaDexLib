//
//  MDParser+MangaInfo.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation
import SwiftSoup

extension MDParser {

    /// The name of the class to lookup in the extracted html of MangaDex homepages
    /// to get a manga's meta information
    static private let mangaInfoMetaTag = "head"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's title
    static private let mangaInfoTitleSelector = "meta[property=og:title]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's description
    static private let mangaInfoDescriptionSelector = "meta[property=og:description]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's cover URL
    static private let mangaInfoImageSelector = "meta[property=og:image]"

    /// The selector to lookup in the extracted html's meta tags
    /// to get a manga's link
    static private let mangaInfoHrefSelector = "link[rel=canonical]"

    /// Convenience method to get an attribute out an `Element`
    /// - Parameter attribute: The attribute to extract
    /// - Parameter selector: The selector to use
    /// - Parameter element: The element in which to lookup
    /// - Returns: The attribute's value
    internal func getFirstAttribute(_ attribute: String,
                                    with selector: String,
                                    in element: Element) throws -> String? {
        let elements = try element.select(selector)
        guard let first = elements.first() else {
            return nil
        }
        return try first.attr(attribute)
    }

    /// Extract a manga's info from a manga detail html page
    /// - Parameter content: The html string to parse
    /// - Returns: The extracted manga
    func getMangaInfo(from content: String) throws -> MDManga {
        let doc = try MDParser.parse(html: content)
        let elements = try doc.getElementsByTag(MDParser.mangaInfoMetaTag)

        guard let head = elements.first() else {
            throw MDError.parseElementNotFound
        }

        let description = try getFirstAttribute("content", with: MDParser.mangaInfoDescriptionSelector, in: head)
        let coverUrl = try getFirstAttribute("content", with: MDParser.mangaInfoImageSelector, in: head)

        guard let title = try getFirstAttribute("content", with: MDParser.mangaInfoTitleSelector, in: head) else {
            throw MDError.parseElementNotFound
        }

        guard let href = try getFirstAttribute("href", with: MDParser.mangaInfoHrefSelector, in: head),
            let mangaId = getIdFromHref(href) else {
            throw MDError.parseElementNotFound
        }

        var manga = MDManga(title: title, mangaId: mangaId)
        manga.description = description
        manga.coverUrl = coverUrl
        return manga
    }

}
