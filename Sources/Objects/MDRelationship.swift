//
//  MDRelationship.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an relationship info returned by the MangaDex API
public struct MDRelationship {

    /// The ID of the object referenced by this relationship
    public let objectId: String

    /// The kind of object referenced by this relationship
    public let objectType: MDObjectType

    /// The data returned by the API, if object expansion is used
    public let data: Any?

}

extension MDRelationship: Decodable {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case objectId = "id"
        case objectType = "type"
        case data = "attributes"
    }

    /// Decode attributes as the structure guessed from the objectType
    // swiftlint:disable:next cyclomatic_complexity
    private static func decodeAttributes(for container: KeyedDecodingContainer<MDRelationship.CodingKeys>,
                                         with objectType: MDObjectType) throws -> Any? {
        // Guess the `data` class based on the decoded object type
        switch objectType {
        case .manga:
            return try container.decode(MDManga?.self, forKey: .data)
        case .chapter:
            return try container.decode(MDChapter?.self, forKey: .data)
        case .coverArt:
            return try container.decode(MDCover?.self, forKey: .data)
        case .author, .artist:
            return try container.decode(MDAuthor?.self, forKey: .data)
        case .scanlationGroup:
            return try container.decode(MDGroup?.self, forKey: .data)
        case .tag:
            return try container.decode(MDTag?.self, forKey: .data)
		case .user, .member, .leader:
            return try container.decode(MDUser?.self, forKey: .data)
        case .customList:
            return try container.decode(MDCustomList?.self, forKey: .data)
        case .legacyMapping:
            return try container.decode(MDMapping?.self, forKey: .data)
        case .string:
            return try container.decode(String?.self, forKey: .data)
        case .reportReason:
            return try container.decode(MDReportReason?.self, forKey: .data)
        }
    }

    /// Custom `init` implementation to handle dynamic relationship object types
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decode(String.self, forKey: .objectId)
        objectType = try container.decode(MDObjectType.self, forKey: .objectType)

        // If there is no "attributes" key, then object expansion was not used
        if container.allKeys.contains(.data) {
            data = try MDRelationship.decodeAttributes(for: container, with: objectType)
        } else {
            data = nil
        }
    }

}
