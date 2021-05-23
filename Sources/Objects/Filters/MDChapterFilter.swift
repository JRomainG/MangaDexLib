//
//  MDChapterFilter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 23/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

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

    /// List of languages in which the chapters may be translated
    public var translatedLanguage: [Locale]?

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
    public var order: [MDSortCriteria: MDSortOrder]?

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
        case order
        case ids
    }

    /// Custom `encode` implementation
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try encode(key: .groups, values: groups ?? [], to: &container)
        try container.encode(uploader, forKey: .uploader)
        try container.encode(manga, forKey: .manga)
        try encode(key: .translatedLanguage, locales: translatedLanguage ?? [], to: &container)
        try container.encode(volume, forKey: .volume)
        try container.encode(chapter, forKey: .chapter)
        try container.encode(createdAtSince, forKey: .createdAtSince)
        try container.encode(updatedAtSince, forKey: .updatedAtSince)
        try container.encode(publishedAtSince, forKey: .publishedAtSince)
        try encode(key: .order, order: order ?? [:], to: &container)
        try encode(key: .ids, values: ids ?? [], to: &container)
        try super.encode(to: encoder)
    }

}
