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

        if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
        }

        return try decoder.decode(T.self, from: jsonData)
    }

    /// Encode an object to a dictionary
    /// - Parameter object: The type of object to return
    /// - Returns: The instanciated object
    static func encode<T: Encodable>(object: T) throws -> [String: Any]? {
        // Make sure dates are formatted in the way the MangaDex API expects them to be
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)
        let data = try encoder.encode(object)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }

}
