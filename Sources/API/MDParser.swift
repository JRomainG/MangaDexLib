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
    static func parse<T>(json: String, type: T.Type) throws -> T where T: Decodable {
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: jsonData)
    }

}
