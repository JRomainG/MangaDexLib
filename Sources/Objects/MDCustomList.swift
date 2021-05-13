//
//  MDCustomList.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a custom list returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDCustomList {

    /// The custom list's name
    public let name: String

    /// The custom list's visibility
    public var visibility: MDCustomListVisibility

    /// The custom list's visibility
    public var owner: MDObject<MDUser>?

    /// The list of manga UUIDs
    /// - Important: This is only used when creating a new list, it will never be filled when decoding
    public let mangas: [String]?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDCustomList: Decodable {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case name
        case visibility
        case owner
        case mangas = "manga"
        case version
    }

}

extension MDCustomList: Encodable {

    /// Custom `encode` implementation to convert this structure to a JSON object
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(mangas, forKey: .mangas)
        try container.encode(version, forKey: .version)
    }

}
