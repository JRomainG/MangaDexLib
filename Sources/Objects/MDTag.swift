//
//  MDTag.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a tag returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDTag {

    /// The tag's name
    public let name: MDLocalizedString

    /// The tag's description
    public let description: MDLocalizedString?

    /// The tag's group
    public let group: String?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDTag: Decodable {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case group
        case version
    }

    /// Custom `init` implementation to handle decoding the `description` if it's empty
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(MDLocalizedString.self, forKey: .name)
        group = try container.decode(String.self, forKey: .group)
        version = try container.decode(Int.self, forKey: .version)

        // Manually decode the description as, when empty, it is returned as an empty array instead of an empty dict
        // See https://github.com/JRomainG/MangaDexLib/issues/3
        do {
            description = try container.decode(MDLocalizedString?.self, forKey: .description)
        } catch is DecodingError {
            description = nil
        }
    }

}
