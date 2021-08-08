//
//  MDPaginationFilter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 10/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// A superclass for filters used during search
public class MDPaginationFilter: Encodable {

    /// The maximum number of results to be returned by the MangaDex API
    /// - Note: This cannot be greater than 100. If `nil`, the API defaults to 10 results
    public var limit: Int?

    /// The offset of the first result to be returned by the MangaDex API
    ///
    /// This is used for paging when there are too many results to return in one response
    public var offset: Int?

    /// Get the query parameters for this filter to encode them in a URL
    internal func getParameters() -> [URLQueryItem] {
        // Convert the filter to a dictionary which is easy to encode in the URL
        let data: [String: Any]
        do {
            data = try MDParser.encode(object: self) ?? [:]
        } catch {
            return []
        }

        // Create a URLQueryItem for each dictionary entry
        var params: [URLQueryItem] = []
        for (key, value) in data {
            // Special case for arrays to handle the specific key format
            // By construction, only arrays of strings should be passed here (see the various `encode` methods)
            if let stringArray = value as? [String] {
                for i in 0..<stringArray.count {
                    let itemKey = "\(key)[\(i)]"
                    params.append(URLQueryItem(name: itemKey, value: stringArray[i]))
                }
            } else {
                params.append(URLQueryItem(name: key, value: value as? String))
            }
        }
        return params
    }

    /// Convenience function to create an empty filter
    public init() {
    }

    /// Custom `encode` implementation
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Convert the integers to strings to make our lives easier in `getParameters`
        if limit != nil {
            try container.encode(String(limit!), forKey: CodingKeys(stringValue: "limit")!)
        }
        if offset != nil {
            try container.encode(String(offset!), forKey: CodingKeys(stringValue: "offset")!)
        }
    }

    /// Helper function to encode an arbitrary value
    internal func encode<T: Encodable, K: CodingKey>(key: K,
                                                     value: T,
                                                     to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        let valKey = CodingKeys(stringValue: key.stringValue)!
        try container.encode(value, forKey: valKey)
    }

    /// Helper function to encode a list of locales
    internal func encode<K: CodingKey>(key: K,
                                       locales: [Locale],
                                       to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        let codingKey = CodingKeys(stringValue: key.stringValue)!
        try container.encode(locales.map({ (locale) -> String? in
            return locale.languageCode
        }), forKey: codingKey)
    }

    /// Helper function to encode a list of codable objects
    internal func encode<K: CodingKey, T: Codable>(key: K,
                                                   values: [T],
                                                   to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        let encoder = JSONEncoder()
        let codingKey = CodingKeys(stringValue: key.stringValue)!
        try container.encode(values.map({ (value) -> String? in
            let encoded = try encoder.encode(value)
            return try JSONSerialization.jsonObject(with: encoded, options: .allowFragments) as? String
        }), forKey: codingKey)
    }

    /// Helper function to encode a sort order
    internal func encode<K: CodingKey>(key: K,
                                       order: [MDSortCriteria: MDSortOrder],
                                       to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        for (sortCriteria, sortOrder) in order {
            let valKey = CodingKeys(stringValue: "\(key.stringValue)[\(sortCriteria.rawValue)]")!
            try container.encode(sortOrder.rawValue, forKey: valKey)
        }
    }

    /// Dynamic coding keys to encode lists and structures
    internal struct CodingKeys: CodingKey {

        // All keys will be strings
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // Return nil since we know keys are strings
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }

    }

}
