//
//  MDAuthor.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an author returned by MangaDex
public struct MDAuthor: Decodable {

    /// The id of the author
    public var authorId: String

    /// The author's name
    public let name: String

    /// The URL of this author's cover image
    public var imageURL: URL?

    /// The author's biography
    public let biography: [MDLocalizedString]

    /// The date at which this author entry was created on MangaDex
    public let createdDate: Date

    /// The date of the last update made to this author's information on MangaDex
    ///
    /// This property will be `nil` if the author was never modified after being created
    public let updatedDate: Date?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDAuthor {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case authorId = "id"
        case name
        case imageURL
        case biography
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case version
    }

    /// Custom `init` implementation to handle the fact that structures are encapsulated in an `MDObject`
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MDObject.CodingKeys.self)
        self = try container.decode(MDAuthor.self, forKey: .attributes)
        self.authorId = try container.decode(String.self, forKey: .objectId)
    }

}
