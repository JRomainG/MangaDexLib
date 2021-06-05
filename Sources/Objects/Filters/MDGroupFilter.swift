//
//  MDGroupFilter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 23/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// A class used to filter scanlation group results during search
public class MDGroupFilter: MDPaginationFilter {

    /// Name of the scanlation group to search for
    public var name: String?

    /// A list of object ids to which to limit the results
    /// - Note: Limited to 100 per request
    public var ids: [String]?

    /// Convenience function to create an empty filter
    override public init() {
        super.init()
    }

    /// Convenience init to search for scanlation groups by name
    /// - Parameter title: the title search string
    public init(name: String) {
        self.name = name
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case name
        case ids
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MDPaginationFilter.CodingKeys.self)
        try encode(key: CodingKeys.name, value: name, to: &container)
        try encode(key: CodingKeys.ids, values: ids ?? [], to: &container)
        try super.encode(to: encoder)
    }

}
