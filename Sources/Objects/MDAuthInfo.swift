//
//  MDAuthInfo.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 09/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing the result of a `/auth/check` request returned by the MangaDex API
public struct MDAuthInfo: Decodable {

    /// The status of the result returned by the MangaDex API
    public let status: MDResultStatus

    /// Whether a JWT provides authentication
    /// - Note: This will be `nil` if the status is not `ok`
    public let authenticated: Bool?

    /// List of roles associated to a session JWT
    /// - Note: This will be `nil` if the status is not `ok`
    public let roles: [MDRole]?

    /// List of permissions associated to a session JWT
    /// - Note: This will be `nil` if the status is not `ok`
    public let permissions: [MDPermission]?

    /// The optional message in this result
    public let message: String?

    /// The errors contained in this response
    /// - Note: This will be `nil` if the status is `ok`
    public let errors: [MDError]?

}

extension MDAuthInfo {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case status = "result"
        case authenticated = "isAuthenticated"
        case roles
        case permissions
        case message
        case errors
    }

}
