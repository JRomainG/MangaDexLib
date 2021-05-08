//
//  MDParser+Api.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

class MDParser {

    /// Parse a JSON string to the given type
    /// - Parameter json: The string to parse
    /// - Parameter type: The type of object to return
    /// - Returns: The instanciated object
    static func parse<T: Decodable>(json: String, type: T.Type) throws -> T {
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: jsonData)
    }

    /// Parse a list of results returned by the MangaDex API
    /// - Parameter json: The json string to parse
    /// - Returns: The parsed list of results
    func parseResultList(from json: String) throws -> MDResultList {
        return try MDParser.parse(json: json, type: MDResultList.self)
    }

    /// Parse a unique result returned by the MangaDex API
    /// - Parameter json: The json string to parse
    /// - Returns: The parsed result
    func parseResult(from json: String) throws -> MDResult {
        return try MDParser.parse(json: json, type: MDResult.self)
    }

}
