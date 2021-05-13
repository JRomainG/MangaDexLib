//
//  MDAuthor.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an author returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDAuthor {

    /// The author's name
    public let name: String

    /// The URL of this author's cover image
    public var imageURL: URL?

    /// The author's biography
    public let biography: [MDLocalizedString]

    /// The date at which this author entry was created on MangaDex
    public let createdDate: Date

    /// The date of the last update made to this author's information on MangaDex
    /// - Note: This property will be `nil` if the author was never modified after being created
    public let updatedDate: Date?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDAuthor: Decodable {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL
        case biography
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case version
    }

}

extension MDAuthor: Encodable {

    /// Convenience `init` used for create/update endpoints
    public init(name: String) {
        self.name = name

        // Unused during upload
        imageURL = nil
        biography = []
        createdDate = .init()
        updatedDate = nil

        // Hardcoded based on the API version we support
        version = 1
    }

    /// Custom `encode` implementation to convert this structure to a JSON object
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(version, forKey: .version)
    }

}
