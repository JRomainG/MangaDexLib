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
        var container = encoder.container(keyedBy: MDPaginationFilter.CodingKeys.self)
        try encode(key: CodingKeys.title, value: title, to: &container)
        try encode(key: CodingKeys.groups, values: groups ?? [], to: &container)
        try encode(key: CodingKeys.uploader, value: uploader, to: &container)
        try encode(key: CodingKeys.manga, value: manga, to: &container)
        try encode(key: CodingKeys.translatedLanguage, locales: translatedLanguage ?? [], to: &container)
        try encode(key: CodingKeys.volume, value: volume, to: &container)
        try encode(key: CodingKeys.chapter, value: chapter, to: &container)
        try encode(key: CodingKeys.createdAtSince, value: createdAtSince, to: &container)
        try encode(key: CodingKeys.updatedAtSince, value: updatedAtSince, to: &container)
        try encode(key: CodingKeys.publishedAtSince, value: publishedAtSince, to: &container)
        try encode(key: CodingKeys.order, order: order ?? [:], to: &container)
        try encode(key: CodingKeys.ids, values: ids ?? [], to: &container)
        try super.encode(to: encoder)
    }

}
