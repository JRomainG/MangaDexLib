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

    /// The group's leader
    public let leader: MDObject<MDUser>?

    /// The list of members of this group
    /// - Note: The leader is not included in this list
    public let members: [MDObject<MDUser>]

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
        case leader
        case members
        case locked
        case website
        case ircServer
        case ircChannel
        case discord
        case contactEmail
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case leaderId
        case memberIds
        case version
    }

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(String.self, forKey: .name)
		description = try container.decodeIfPresent(String.self, forKey: .description)
		leader = try? container.decodeIfPresent(MDObject<MDUser>.self, forKey: .leader)
		members = try container.decodeIfPresent([MDObject<MDUser>].self, forKey: .members) ?? []
		locked = try container.decodeIfPresent(Bool.self, forKey: .locked)
		website = try container.decodeIfPresent(URL.self, forKey: .website)
		ircServer = try container.decodeIfPresent(String.self, forKey: .ircServer)
		ircChannel = try container.decodeIfPresent(String.self, forKey: .ircChannel)
		discord = try container.decodeIfPresent(String.self, forKey: .discord)
		contactEmail = try container.decodeIfPresent(String.self, forKey: .contactEmail)
		createdDate = try container.decode(Date.self, forKey: .createdDate)
		updatedDate = try container.decodeIfPresent(Date.self, forKey: .updatedDate)
		leaderId = try container.decodeIfPresent(String.self, forKey: .leaderId)
		memberIds = try container.decodeIfPresent([String].self, forKey: .memberIds)
		version = try container.decode(Int.self, forKey: .version)
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
        leader = MDObject(objectId: "", objectType: .user, data: MDUser(username: nil, version: 1))
        members = []
        createdDate = .init()
        updatedDate = nil

        // Hardcoded based on the API version we support
        version = 3
    }

    /// Custom `encode` implementation to convert this structure to a JSON object
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(leaderId, forKey: .leader)
        try container.encode(memberIds, forKey: .members)
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
