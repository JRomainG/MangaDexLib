//
//  MDManga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a manga returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDManga {

    /// The manga's title
    public let title: MDLocalizedString

    /// Alternative titles for this manga (e.g. when a manga is commonly known under multiple names)
    public let altTitles: [MDLocalizedString]

    /// The manga's description
    public let description: MDLocalizedString?

    /// A boolean indicating whether the mange is locked (cannot be edited)
    public let locked: Bool

    /// The original language in which this manga was published
    public let originalLanguage: Locale?

    /// The volume in which the last chapter was published
    /// - Note: This can be `nil` if the last chapter hasn't been uploaded. Bonus chapters do not count
    public let lastVolume: Int?

    /// A string indicating which chapter marks the end of the manga (usually represents a float, e.g. 142.5)
    /// - Note: This can be `nil` if the last chapter hasn't been uploaded. Bonus chapters do not count
    public let lastChapter: String?

    /// The demographic to which this manga is targeted
    public let demographic: MDDemographic?

    /// The manga's publication status
    public let publicationStatus: MDPublicationStatus?

    /// The year this manga was created
    public let year: Int?

    /// This manga's content rating
    public let rating: MDContentRating?

    /// The manga's tags
    public let tags: [MDObject<MDTag>]

    /// The date at which this manga entry was created *on MangaDex*
    public let createdDate: Date

    /// The date of the last update made to this manga entry *on MangaDex*
    ///
    /// This property will be `nil` if the manga was never updated after being created
    public let updatedDate: Date?

    /// A set of links to external websites
    public let links: [MDExternalLink]

    /// A note about this manga left for the moderators
    /// - Important: This is only used when uploading or updating a manga, it will never be filled when decoding
    public let modNotes: String?

    /// A list of authors' uuids
    /// - Important: This is only used when uploading or updating a manga, it will never be filled when decoding.
    /// Use `MDObject.relationships` instead
    public let authors: [String]?

    /// A list of arists' uuids
    /// - Important: This is only used when uploading or updating a manga, it will never be filled when decoding.
    /// Use `MDObject.relationships` instead
    public let artists: [String]?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDManga: Decodable {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case title
        case altTitles
        case description
        case locked = "isLocked"
        case originalLanguage
        case lastVolume
        case lastChapter
        case demographic = "publicationDemographic"
        case publicationStatus = "status"
        case year
        case rating = "contentRating"
        case tags
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case links
        case modNotes
        case authors
        case artists
        case version
    }

    /// Custom `init` implementation to handle decoding the `originalLanguage` and `links` attributes
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(MDLocalizedString.self, forKey: .title)
        altTitles = try container.decode([MDLocalizedString].self, forKey: .altTitles)
        description = try container.decode(MDLocalizedString?.self, forKey: .description)
        locked = try container.decode(Bool.self, forKey: .locked)
        lastVolume = try container.decode(Int?.self, forKey: .lastVolume)
        lastChapter = try container.decode(String?.self, forKey: .lastChapter)
        demographic = try container.decode(MDDemographic?.self, forKey: .demographic)
        publicationStatus = try container.decode(MDPublicationStatus?.self, forKey: .publicationStatus)
        year = try container.decode(Int?.self, forKey: .year)
        rating = try container.decode(MDContentRating?.self, forKey: .rating)
        tags = try container.decode([MDObject<MDTag>].self, forKey: .tags)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        updatedDate = try container.decode(Date?.self, forKey: .updatedDate)
        version = try container.decode(Int.self, forKey: .version)

        // Manually decode the language code to convert it from a String to a Locale
        if let langCode = try container.decode(String?.self, forKey: .originalLanguage) {
            originalLanguage = Locale.init(identifier: langCode)
        } else {
            originalLanguage = nil
        }

        /// Manually decode the links as we want to flatten the dictionary
        let rawLinks = try container.decode([String: String]?.self, forKey: .links) ?? [:]
        var tmp: [MDExternalLink] = []
        for (key, value) in rawLinks {
            tmp.append(MDExternalLink(key: key, value: value))
        }
        links = tmp

        // These properties are only used for encoding
        authors = nil
        artists = nil
        modNotes = nil
    }

}

extension MDManga: Encodable {

    /// Custom `encode` implementation to handle encoding the `originalLanguage` and `links` attributes
    ///
    /// The MangaDex API does not expect the same thing when encoding an `MDManga` as when decoding it, which makes this
    /// a bit awkward. See https://api.mangadex.org/docs.html#operation/post-manga for more details
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(altTitles, forKey: .altTitles)
        try container.encode(description, forKey: .description)
        try container.encode(lastVolume, forKey: .lastVolume)
        try container.encode(lastChapter, forKey: .lastChapter)
        try container.encode(demographic, forKey: .demographic)
        try container.encode(publicationStatus, forKey: .publicationStatus)
        try container.encode(year, forKey: .year)
        try container.encode(rating, forKey: .rating)
        try container.encode(modNotes, forKey: .modNotes)
        try container.encode(version, forKey: .version)

        // Manually encode the language code
        try container.encode(originalLanguage?.identifier, forKey: .originalLanguage)

        /// Manually encode the links
        for link in links {
            try container.encode(link.rawValue, forKey: CodingKeys.init(stringValue: link.linkType.rawValue)!)
        }

        // Manually encode the authors and artists, which should be in MDObject.relationships, but have to be stored
        // here for upload...
        try container.encode(authors ?? [], forKey: .authors)
        try container.encode(artists ?? [], forKey: .artists)
    }

}
