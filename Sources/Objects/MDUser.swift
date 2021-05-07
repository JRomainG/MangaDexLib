//
//  MDUser.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a user returned by MangaDex
public struct MDUser: Decodable {

    /// The id of the chapter
    public var userId: String

    /// the logged-in user's display name
    public let username: String?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDUser {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case username
        case version
    }

    /// Custom `init` implementation to handle the fact that structures are encapsulated in an `MDObject`
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MDObject.CodingKeys.self)
        self = try container.decode(MDUser.self, forKey: .attributes)
        self.userId = try container.decode(String.self, forKey: .objectId)
    }

}
