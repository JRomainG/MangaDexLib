//
//  MDGroup.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a group returned by MangaDex
public struct MDGroup: Decodable {

    /// The id of the group
    public var groupId: String

    /// The group's name
    public let name: String

    /// The group's leader
    public let leader: MDUser

    /// The list of members of this group
    /// - Note: The leader is not included in this list
    public let members: [MDUser]

    /// The date at which this group was created on MangaDex
    public let createdDate: Date

    /// The date of the last update made to this group's information on MangaDex
    /// - Note: This property will be `nil` if the group was never modified after being created
    public let updatedDate: Date?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}

extension MDGroup {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case groupId = "id"
        case name
        case leader
        case members
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case version
    }

    /// Custom `init` implementation to handle the fact that structures are encapsulated in an `MDObject`
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MDObject.CodingKeys.self)
        self = try container.decode(MDGroup.self, forKey: .attributes)
        self.groupId = try container.decode(String.self, forKey: .objectId)
    }

}
