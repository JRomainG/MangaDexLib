//
//  MDManga.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a manga returned by MangaDex
public struct MDManga: Decodable {

    /// The id of the manga
    public var mangaId: String?

    /// The manga's title
    public let title: [MDLocalizedString]

    /// Alternative titles for this manga (e.g. when a manga is commonly known under multiple names)
    public let altTitles: [MDLocalizedString]

    /// The manga's description
    public let description: [MDLocalizedString]

    /// A boolean indicating whether the mange is locked (cannot be edited)
    public let locked: Bool

    /// A boolean indicating whether the mange is locked (cannot be edited)
    public let originalLanguage: Locale

    /// A string indicating in which volume the last chapter was published (usually represents an int, e.g. 8)
    ///
    /// This can be `nil` if the last chapter hasn't been uploaded. Bonus chapters do not count
    public let lastVolume: String?

    /// A string indicating which chapter marks the end of the manga (usually represents a float, e.g. 142.5)
    ///
    /// This can be `nil` if the last chapter hasn't been uploaded. Bonus chapters do not count
    public let lastChapter: String?

    /// The demographic to which this manga is targeted
    public let demographic: MDDemographic

    /// The manga's publication status
    public let publicationStatus: MDPublicationStatus

    /// The year this manga was created
    public let year: Int?

    /// This manga's content rating
    public let rating: MDContentRating

    /// The manga's tags
    public let tags: [MDTag]

    /// The date at which this manga entry was created *on MangaDex*
    public let createdDate: Date

    /// The date of the last update made to this manga entry *on MangaDex*
    ///
    /// This property will be `nil` if the manga was never updated after being created
    public let updatedDate: Date?

    /// Resources linked to this manga (e.g. chapters or authors)
    public var relationships: [MDObject]?

    /// A set of links to external websites
    ///
    /// This property should be accessed by calling `getExternalLinks` so they are parsed to a more usable format
    private let links: [MDExternalLink]

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDManga {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case mangaId = "id"
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
        case version
    }

    /// Custom `init` implementation to handle the fact that structures are encapsulated in an `MDObject`
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MDObject.CodingKeys.self)
        self = try container.decode(MDManga.self, forKey: .attributes)
        self.mangaId = try container.decode(String.self, forKey: .objectId)
    }

}
