//
//  MDFilter.swift
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
    public func getParameters() -> [URLQueryItem] {
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
            params.append(URLQueryItem(name: key, value: value as? String))
        }
        return params
    }

    /// Convenience function to create an empty filter
    public init() {
    }

    /// Custom `encode` implementation
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(limit, forKey: .limit)
        try container.encode(offset, forKey: .offset)
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case limit
        case offset
    }

}

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
    /// TODO: The API isn't very clear on how to set this
    // public var order: MDSortOrder?

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
        case ids
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(authors, forKey: .authors)
        try container.encode(artists, forKey: .artists)
        try container.encode(year, forKey: .year)
        try container.encode(includedTags, forKey: .includedTags)
        try container.encode(includedTagsMode, forKey: .includedTagsMode)
        try container.encode(excludedTags, forKey: .excludedTags)
        try container.encode(excludedTagsMode, forKey: .excludedTagsMode)
        try container.encode(statuses, forKey: .statuses)
        try container.encode(originalLanguage, forKey: .originalLanguage)
        try container.encode(publicationDemographic, forKey: .publicationDemographic)
        try container.encode(contentRating, forKey: .contentRating)
        try container.encode(createdAtSince, forKey: .createdAtSince)
        try container.encode(updatedAtSince, forKey: .updatedAtSince)
        try container.encode(ids, forKey: .ids)
        try super.encode(to: encoder)
    }

}

/// A class used to filter chapter results during search
public class MDChapterFilter: MDPaginationFilter {

    /// Title search string
    public var title: String?

    /// List of scanlation group UUIDs
    public var groups: [String]?

    /// Original uploader UUID
    public var uploader: String?

    /// UUID of the manga the chapter must belong to
    public var manga: String?

    /// Language in which the chapter must be translated
    public var translatedLanguage: Locale?

    /// Volume number in which the chapter appears
    public var volume: String?

    /// Chapter number
    public var chapter: String?

    /// Only list results created after this date
    public var createdAtSince: Date?

    /// Only list results updated after this date
    public var updatedAtSince: Date?

    /// Only list results published after this date
    public var publishedAtSince: Date?

    /// Sort order for the results
    /// TODO: The API isn't very clear on how to set this
    // public var order: MDSortOrder?

    /// A list of object ids to which to limit the results
    /// - Note: Limited to 100 per request
    public var ids: [String]?

    /// Convenience function to create an empty filter
    override public init() {
        super.init()
    }

    /// Convenience init to search for chapters by title
    /// - Parameter title: the title search string
    public init(title: String) {
        self.title = title
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case title
        case groups
        case uploader
        case manga
        case translatedLanguage
        case volume
        case chapter
        case createdAtSince
        case updatedAtSince
        case publishedAtSince
        case ids
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(groups, forKey: .groups)
        try container.encode(uploader, forKey: .uploader)
        try container.encode(manga, forKey: .manga)
        try container.encode(translatedLanguage, forKey: .translatedLanguage)
        try container.encode(volume, forKey: .volume)
        try container.encode(chapter, forKey: .chapter)
        try container.encode(createdAtSince, forKey: .createdAtSince)
        try container.encode(updatedAtSince, forKey: .updatedAtSince)
        try container.encode(publishedAtSince, forKey: .publishedAtSince)
        try container.encode(ids, forKey: .ids)
        try super.encode(to: encoder)
    }

}

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
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(ids, forKey: .ids)
        try super.encode(to: encoder)
    }

}

/// A class used to filter scanlation group results during search
public class MDAuthorFilter: MDPaginationFilter {

    /// Name of the author to search for
    public var name: String?

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
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(ids, forKey: .ids)
        try super.encode(to: encoder)
    }

}

/// A class used to filter feeds
public class MDFeedFilter: MDPaginationFilter {

    /// Locale for the chapters to be displayed
    public var locales: [Locale]?

    /// Only list results created after this date
    public var createdAtSince: Date?

    /// Only list results updated after this date
    public var updatedAtSince: Date?

    /// Only list results published after this date
    public var publishedAtSince: Date?

    /// Sort order for the results
    /// TODO: The API isn't very clear on how to set this
    // public var order: MDSortOrder?

    /// Convenience function to create an empty filter
    override public init() {
        super.init()
    }

    /// Convenience init to filter feeds by language
    /// - Parameter locales: the locales to allow
    public init(locales: [Locale]) {
        self.locales = locales
    }

    /// Coding keys to map our struct to JSON data
    enum CodingKeys: String, CodingKey {
        case locales
        case createdAtSince
        case updatedAtSince
        case publishedAtSince
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(locales, forKey: .locales)
        try container.encode(createdAtSince, forKey: .createdAtSince)
        try container.encode(updatedAtSince, forKey: .updatedAtSince)
        try container.encode(publishedAtSince, forKey: .publishedAtSince)

        // Manually encode the language codes
        var langCodes: [String]  = []
        for locale in locales ?? [] {
            langCodes.append(locale.identifier)
        }
        try container.encode(langCodes, forKey: .locales)

        try super.encode(to: encoder)
    }

}
