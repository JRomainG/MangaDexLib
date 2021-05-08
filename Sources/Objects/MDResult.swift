//
//  MDResult.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a result returned by the MangaDex API
public struct MDResult: Decodable {

    /// The status of the result returned by the MangaDex API
    public let status: MDResultStatus

    /// The data contained in this response, formated in JSON
    /// - Note: This will be `nil` if the status is not `ok`
    let jsonData: String?

    /// The relationships contained in this response
    /// - Note: This will be `nil` if the status is not `ok`
    let relationships: [MDObject]?

    /// The token information returned during authentication
    /// - Note: This will be nil for requests outside of the `auth` endpoint
    let token: MDToken?

    /// Whether a JWT provides authentication
    /// - Note: This is only filled when using the `/auth/check` endpoint
    public let authenticated: Bool?

    /// List of roles associated to a session JWT
    /// - Note: This is only filled when using the `/auth/check` endpoint
    public let roles: [MDRole]?

    /// List of permissions associated to a session JWT
    /// - Note: This is only filled when using the `/auth/check` endpoint
    public let permissions: [MDPermission]?

    /// The optional message in this result
    public let message: String?

    /// The errors contained in this response
    /// - Note: This will be `nil` if the status is `ok`
    public let errors: [MDError]?

}

extension MDResult {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case status = "result"
        case jsonData = "data"
        case relationships
        case token
        case authenticated = "isAuthenticated"
        case roles
        case permissions
        case message
        case errors
    }

}
