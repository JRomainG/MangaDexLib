//
//  MDMangaFilter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 23/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// A class used to filter manga results during search
public class MDMangaFilter: MDPaginationFilter {

    /// Title search string
    public var title: String?

    /// List of author UUIDs
    public var authors: [String]?

    /// List of artist UUIDs
    public var artists: [String]?

    /// Year of publication
    public var year: Int?

    /// Tag UUIDs to include
    public var includedTags: [String]?

    /// Included tags filtering mode
    /// - Note: If `nil`, the API defaults to `all`
    public var includedTagsMode: MDTagFilteringMode?

    /// Tag UUIDs to exclude
    public var excludedTags: [String]?

    /// Excluded tags filtering mode
    /// - Note: If `nil`, the API defaults to `all`
    public var excludedTagsMode: MDTagFilteringMode?

    /// Publication statuses to include
    public var statuses: [MDPublicationStatus]?

    /// Original publication languages to include
    public var originalLanguage: [Locale]?

    /// Target demographics to include
    public var publicationDemographic: [MDDemographic]?

    /// Content ratings to include
    public var contentRating: [MDContentRating]?

    /// Only list results created after this date
    public var createdAtSince: Date?

    /// Only list results updated after this date
    public var updatedAtSince: Date?

    /// Sort order for the results
    public var order: [MDSortCriteria: MDSortOrder]?

    /// A list of object ids to which to limit the results
    /// - Note: Limited to 100 per request
    public var ids: [String]?

    /// Convenience function to create an empty filter
    override public init() {
        super.init()
    }

    /// Convenience init to search for mangas by title
    /// - Parameter title: the title search string
    public init(title: String) {
        self.title = title
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case title
        case authors
        case artists
        case year
        case includedTags
        case includedTagsMode
        case excludedTags
        case excludedTagsMode
        case statuses
        case originalLanguage
        case publicationDemographic
        case contentRating
        case createdAtSince
        case updatedAtSince
        case order
        case ids
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MDPaginationFilter.CodingKeys.self)
        try encode(key: CodingKeys.title, value: title, to: &container)
        try encode(key: CodingKeys.year, value: year, to: &container)
        try encode(key: CodingKeys.authors, values: authors ?? [], to: &container)
        try encode(key: CodingKeys.artists, values: artists ?? [], to: &container)
        try encode(key: CodingKeys.includedTags, values: includedTags ?? [], to: &container)
        try encode(key: CodingKeys.includedTagsMode, value: includedTagsMode, to: &container)
        try encode(key: CodingKeys.excludedTags, values: excludedTags ?? [], to: &container)
        try encode(key: CodingKeys.excludedTagsMode, value: excludedTagsMode, to: &container)
        try encode(key: CodingKeys.statuses, values: statuses ?? [], to: &container)
        try encode(key: CodingKeys.originalLanguage, locales: originalLanguage ?? [], to: &container)
        try encode(key: CodingKeys.publicationDemographic, values: publicationDemographic ?? [], to: &container)
        try encode(key: CodingKeys.contentRating, values: contentRating ?? [], to: &container)
        try encode(key: CodingKeys.createdAtSince, value: createdAtSince, to: &container)
        try encode(key: CodingKeys.updatedAtSince, value: updatedAtSince, to: &container)
        try encode(key: CodingKeys.order, order: order ?? [:], to: &container)
        try encode(key: CodingKeys.ids, values: ids ?? [], to: &container)
        try super.encode(to: encoder)
    }

}
