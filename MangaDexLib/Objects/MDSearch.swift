//
//  MDSearch.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Struct representing a search query
public struct MDSearch {

    /// Type of filtering when searching with tags
    public enum TagFilteringMode: String {
        /// Exclude/include mangas with any of the given keywords
        case any = "any"

        /// Only exclude/include mangas with all of the given keywords
        case all = "all"
    }

    /// Options available to select as a work's original language during search
    public let originalLanguages: [MDLanguage] = [
        .english,
        .japanese,
        .polish,
        .russian,
        .german,
        .french,
        .vietnamese,
        .simplifiedChinese,
        .indonesian,
        .korean,
        .latinAmericanSpanish,
        .thai,
        .filipino,
        .traditionalChinese
    ]

    /// Title to lookup (nil means no filter)
    public var title: String?

    /// Author to lookup (nil means no filter)
    public var author: String?

    /// Artist to lookup (nil means no filter)
    public var artist: String?

    /// Original language of the  mangas to lookup (nil means any)
    public var originalLanguage: MDLanguage?

    /// Demographics of the  mangas to lookup (empty means no filter)
    public var demographics: [MDDemographic] = []

    /// Publication status of the  mangas to lookup (empty means no filter)
    public var publicationStatuses: [MDPublicationStatus] = []

    /// Tags to allow in the mangas to lookup (empty means no filter)
    public var includeTags: [Int] = []

    /// Tags to forbid in the mangas to lookup (empty means no filter)
    public var excludeTags: [Int] = []

    /// Type of filter to apply for tag inclusion
    public var includeTagsMode: TagFilteringMode = .all

    /// Type of filter to apply for tag exclusion
    public var excludeTagsMode: TagFilteringMode = .any

    /// Convenience method to init an empty search instance
    init() {
    }

    /// Convenience method to init a simple search instance
    public init(title: String?) {
        self.title = title
    }

    /// Convenience method to init an advanced search instance
    public init(title: String?,
                author: String?,
                artist: String?,
                originalLanguage: MDLanguage?,
                demographics: [MDDemographic],
                publicationStatuses: [MDPublicationStatus],
                includeTags: [Int],
                excludeTags: [Int],
                includeTagsMode: TagFilteringMode,
                excludeTagsMode: TagFilteringMode) {
        self.title = title
        self.author = author
        self.artist = artist
        self.originalLanguage = originalLanguage
        self.demographics = demographics
        self.publicationStatuses = publicationStatuses
        self.includeTags = includeTags
        self.excludeTags = excludeTags
        self.includeTagsMode = includeTagsMode
        self.excludeTagsMode = excludeTagsMode
    }

}
