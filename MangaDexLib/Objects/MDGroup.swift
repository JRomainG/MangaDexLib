//
//  MDGroup.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a group returned by MangaDex
struct MDGroup {

    /// The id of the group
    var groupId: Int

    /// The name of the group
    var name: String?

    /// The URL of this group's cover image
    var coverUrl: String?

    /// A list of links for this group
    var links: [String]?

    /// The leader of this group
    var leader: MDUser?

    /// The list of members in this group
    var members: [MDUser]?

    /// A convenience method to create a group with only an id
    init(groupId: Int) {
        self.groupId = groupId
    }

    /// A convenience method to create a group with a name and id only
    init(name: String, groupId: Int) {
        self.name = name
        self.groupId = groupId
    }

}
