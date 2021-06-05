//
//  MDCoverFilter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 23/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// A class used to filter covers
public class MDCoverFilter: MDPaginationFilter {

    /// Mangas for which covers should be listed
    public var mangas: [String]?

    /// A list of uploader UUIDs
    /// - Note: Limited to 100 per request
    public var uploaders: [String]?

    /// Sort order for the results
    public var order: [MDSortCriteria: MDSortOrder]?

    /// A list of object ids to which to limit the results
    /// - Note: Limited to 100 per request
    public var ids: [String]?

    /// Convenience function to create an empty filter
    override public init() {
        super.init()
    }

    /// Convenience init to filter covers by manga
    /// - Parameter mangas: the list of mangaIds for which covers should be listed
    public init(mangas: [String]) {
        self.mangas = mangas
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case mangas = "manga"
        case uploaders
        case order
        case ids
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MDPaginationFilter.CodingKeys.self)
        try encode(key: CodingKeys.mangas, values: mangas ?? [], to: &container)
        try encode(key: CodingKeys.uploaders, values: uploaders ?? [], to: &container)
        try encode(key: CodingKeys.order, order: order ?? [:], to: &container)
        try encode(key: CodingKeys.ids, values: ids ?? [], to: &container)
        try super.encode(to: encoder)
    }

}
