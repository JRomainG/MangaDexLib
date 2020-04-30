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

    /// Parse an HTML string to a Document object
    /// - Parameter html: The string to parse
    /// - Returns: The parsed document
    static func parse(html: String) throws -> Document {
        return try SwiftSoup.parse(html)
    }

    /// Parse a JSON string to the given type
    /// - Parameter json: The string to parse
    /// - Returns: The instanciated object
    static func parse<T>(json: String, type: T.Type) throws -> T where T: Decodable {
        let jsonData = json.data(using: .utf8)!
        return try JSONDecoder().decode(T.self, from: jsonData)
    }

}

// MARK: - MDParser Common Manga Methods

extension MDParser {

    /// Split an absolute of relative URL's path in a normalized way
    func splitUrlPath(_ href: String) -> [String] {
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

    /// Extract the id from the link to a manga or user
    ///
    /// The format is `/title/[id]/[manga-name]`, absolute and relative URLs are handled
    func getIdFromHref(_ href: String) -> Int? {
        let components = splitUrlPath(href)
        guard components.count >= 2 else {
            return nil
        }
        return Int(components[1])
    }

}
