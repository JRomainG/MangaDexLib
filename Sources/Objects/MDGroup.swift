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

    /// The group's description
    public let description: String?

    /// Whether this scanlation group is locked or not
    public let locked: Bool?

    /// An optional URL to the group's website
    public let website: URL?

    /// An optional host of the group's IRC server
    public let ircServer: String?

    /// An optional ID of the group's IRC channel
    public let ircChannel: String?

    /// An optional ID of the group's Discord server
    public let discord: String?

    /// An optional email for the group
    public let contactEmail: String?

    /// The date at which this group was created on MangaDex
    public let createdDate: Date

    /// The date of the last update made to this group's information on MangaDex
    /// - Note: This property will be `nil` if the group was never modified after being created
    public let updatedDate: Date?

    /// The group leader's UUID
    /// - Important: This is only used when uploading or updating a group, it will never be filled when decoding
    internal let leaderId: String?

    /// The list of members of this group
    /// - Note: The leader should not be included in this list
    /// - Important: This is only used when uploading or updating a group, it will never be filled when decoding
    internal let memberIds: [String]?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDGroup: Decodable {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case locked
        case website
        case ircServer
        case ircChannel
        case discord
        case contactEmail
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case leaderId = "leader"
        case memberIds = "members"
        case version
    }
}

extension MDGroup: Encodable {

    /// Convenience `init` used for create/update endpoints
    public init(name: String,
                leaderId: String,
                memberIds: [String],
                locked: Bool,
                website: URL?,
                ircServer: String?,
                ircChannel: String?,
                discord: String?,
                contactEmail: String?,
                description: String?) {
        self.name = name
        self.leaderId = leaderId
        self.memberIds = memberIds
        self.locked = locked
        self.website = website
        self.ircServer = ircServer
        self.ircChannel = ircChannel
        self.discord = discord
        self.contactEmail = contactEmail
        self.description = description

        // Unused during upload
        createdDate = .init()
        updatedDate = nil

        // Hardcoded based on the API version we support
        version = 3
    }

    /// Custom `encode` implementation to convert this structure to a JSON object
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(leaderId, forKey: .leaderId)
        try container.encode(memberIds, forKey: .memberIds)
        try container.encode(locked, forKey: .locked)
        try container.encode(website, forKey: .website)
        try container.encode(ircServer, forKey: .ircServer)
        try container.encode(ircChannel, forKey: .ircChannel)
        try container.encode(discord, forKey: .discord)
        try container.encode(contactEmail, forKey: .contactEmail)
        try container.encode(description, forKey: .description)
        try container.encode(version, forKey: .version)
    }

}
