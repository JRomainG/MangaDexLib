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
public struct MDTag: Decodable {

    /// The tag's name
    public let name: MDLocalizedString

    /// The tag's description
    /// TODO: The API returns a list instead of a dict here
    // public let description: MDLocalizedString

    /// The tag's group
    public let group: String?

    /// The version of this type of object in the MangaDex API
    public let version: Int

}
