//
//  MDAuthorFilter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 23/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// A class used to filter scanlation group results during search
public class MDAuthorFilter: MDPaginationFilter {

    /// Name of the author to search for
    public var name: String?

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
    public init(name: String) {
        self.name = name
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case name
        case ids
        case order
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try encode(key: .order, order: order ?? [:], to: &container)
        try encode(key: .ids, values: ids ?? [], to: &container)
        try super.encode(to: encoder)
    }

}
