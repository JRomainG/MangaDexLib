//
//  MDTag.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a tag returned by MangaDex
public struct MDTag: Decodable {

    /// The id of the tag
    public var tagId: String

    /// The tag's name
    public let name: [MDLocalizedString]

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDTag {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case tagId = "id"
        case name
        case version
    }

    /// Custom `init` implementation to handle the fact that structures are encapsulated in an `MDObject`
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MDObject.CodingKeys.self)
        self = try container.decode(MDTag.self, forKey: .attributes)
        self.tagId = try container.decode(String.self, forKey: .objectId)
    }

}
