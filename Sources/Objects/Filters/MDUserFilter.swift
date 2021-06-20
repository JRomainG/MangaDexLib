//
//  MDUserFilter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 10/06/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// A class used to filter user results during search
public class MDUserFilter: MDPaginationFilter {

    /// Name of the user to search for
    public var username: String?

    /// Sort order for the results
    public var order: [MDSortCriteria: MDSortOrder]?

    /// A list of object ids to which to limit the results
    /// - Note: Limited to 100 per request
    public var ids: [String]?

    /// Convenience function to create an empty filter
    override public init() {
        super.init()
    }

    /// Convenience init to search for authors by name
    /// - Parameter title: the title search string
    public init(username: String) {
        self.username = username
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case username
        case ids
        case order
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MDPaginationFilter.CodingKeys.self)
        try encode(key: CodingKeys.username, value: username, to: &container)
        try encode(key: CodingKeys.order, order: order ?? [:], to: &container)
        try encode(key: CodingKeys.ids, values: ids ?? [], to: &container)
        try super.encode(to: encoder)
    }

}
