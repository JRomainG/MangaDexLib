//
//  MDGroup.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a group returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDGroup {

    /// The group's name
    public let name: String

    /// The group's leader
    public let leader: MDObject<MDUser>

    /// The list of members of this group
    /// - Note: The leader is not included in this list
    public let members: [MDObject<MDUser>]

    /// The date at which this group was created on MangaDex
    public let createdDate: Date

    /// The date of the last update made to this group's information on MangaDex
    /// - Note: This property will be `nil` if the group was never modified after being created
    public let updatedDate: Date?

    /// The group leader's UUID
    /// - Important: This is only used when uploading a chapter, it will never be filled when decoding
    public let leaderId: String?

    /// The list of members of this group
    /// - Note: The leader should not be included in this list
    /// - Important: This is only used when uploading a chapter, it will never be filled when decoding
    public let memberIds: [String]?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDGroup: Decodable {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case name
        case leader
        case members
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case leaderId
        case memberIds
        case version
    }

}

extension MDGroup: Encodable {

    /// Custom `encode` implementation to convert this structure to a JSON object
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(leaderId, forKey: .leader)
        try container.encode(memberIds, forKey: .members)
        try container.encode(version, forKey: .version)
    }

}
