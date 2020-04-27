//
//  MDSearch.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a search query
class MDSearch: NSObject {

    // swiftlint:disable redundant_string_enum_value
    /// Type of filtering when searching with tags
    enum TagFilteringMode: String {
        case any = "any"
        case all = "all"
    }
    // swiftlint:enable redundant_string_enum_value

    /// Type of parameter using during the request for search
    enum Parameter: String {
        case title = "title"
        case author = "author"
        case artist = "artist"
        case originalLanguage = "lang_id"
        case demographics = "demos"
        case publicationStatuses = "statuses"
        case tags = "tags"
        case includeTagsMode = "tag_mode_inc"
        case excludeTagsMode = "tag_mode_exc"
    }

    /// Options available to select as a work's original language during search
    let originalLanguages: [Language] = [
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
    var title: String?

    /// Author to lookup (nil means no filter)
    var author: String?

    /// Artist to lookup (nil means no filter)
    var artist: String?

    /// Original language of the  mangas to lookup (nil means any)
    var originalLanguage: Language?

    /// Demographics of the  mangas to lookup (empty means no filter)
    var demographics: [Demographic] = []

    /// Publication status of the  mangas to lookup (empty means no filter)
    var publicationStatuses: [PublicationStatus] = []

    /// Tags to allow in the mangas to lookup (empty means no filter)
    var includeTags: [Int] = []

    /// Tags to forbid in the mangas to lookup (empty means no filter)
    var excludeTags: [Int] = []

    /// Type of filter to apply for tag inclusion
    var includeTagsMode: TagFilteringMode = .all

    /// Type of filter to apply for tag exclusion
    var excludeTagsMode: TagFilteringMode = .any

    /// Convenience method to init an empty search instance
    override init() {
    }

    /// Convenience method to init a simple search instance
    init(title: String?) {
        self.title = title
    }

    /// Convenience method to init an advanced search instance
    init(title: String?,
         author: String?,
         artist: String?,
         originalLanguage: Language?,
         demographics: [Demographic],
         publicationStatuses: [PublicationStatus],
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
