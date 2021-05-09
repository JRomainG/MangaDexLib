//
//  MDUser.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a user returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDUser: Decodable {

    /// the logged-in user's display name
    public let username: String?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}
