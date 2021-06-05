//
//  MDFeedFilter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 23/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// A class used to filter feeds
public class MDFeedFilter: MDPaginationFilter {

    /// Language for the chapters to be displayed
    public var translatedLanguage: [Locale]?

    /// Only list results created after this date
    public var createdAtSince: Date?

    /// Only list results updated after this date
    public var updatedAtSince: Date?

    /// Only list results published after this date
    public var publishedAtSince: Date?

    /// Sort order for the results
    public var order: [MDSortCriteria: MDSortOrder]?

    /// Convenience function to create an empty filter
    override public init() {
        super.init()
    }

    /// Convenience init to filter feeds by language
    /// - Parameter locales: the locales to allow
    public init(locales: [Locale]) {
        self.translatedLanguage = locales
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case translatedLanguage
        case createdAtSince
        case updatedAtSince
        case publishedAtSince
        case order
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MDPaginationFilter.CodingKeys.self)
        try encode(key: CodingKeys.translatedLanguage, locales: translatedLanguage ?? [], to: &container)
        try encode(key: CodingKeys.createdAtSince, value: createdAtSince, to: &container)
        try encode(key: CodingKeys.updatedAtSince, value: updatedAtSince, to: &container)
        try encode(key: CodingKeys.publishedAtSince, value: publishedAtSince, to: &container)
        try encode(key: CodingKeys.order, order: order ?? [:], to: &container)
        try super.encode(to: encoder)
    }

}
