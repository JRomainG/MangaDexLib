//
//  MDUser.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a user returned by MangaDex
struct MDUser {

    /// The id of the chapter
    var userId: Int

    /// The user's display name
    var name: String?

    /// The user's rank
    var rank: String?

    /// The user's avatar URL
    var avatar: String?

}
