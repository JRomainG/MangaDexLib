//
//  MDToken.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 08/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a token returned by MangaDex
public struct MDToken: Decodable {

    /// The session token
    let sessionJwt: String

    /// The refresh token
    let refreshJwt: String

}

extension MDToken {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case sessionJwt = "session"
        case refreshJwt = "refresh"
    }

}
