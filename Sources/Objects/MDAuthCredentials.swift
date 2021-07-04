//
//  MDAuthCredentials.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 08/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure to store credentials when attempting to login
public struct MDAuthCredentials: Encodable {

    /// Authentication modes provided by MangaDex
    public enum AuthMode: String {
        /// Login using a username and password
        case usernamePassword
        // case twoFactor
    }

    /// The authentication mode to use
    let authMode: AuthMode

    /// The username to use
    ///
    /// Must be between 1 and 64 characters
    public let username: String

    /// The password to use
    ///
    /// Must be between 8 and 1024 characters
    public let password: String

    // public let twoFactorCode: String?

    /// Helper method to login using a username and password
    public init(username: String, password: String) {
        self.username = username
        self.password = password
        self.authMode = .usernamePassword
    }

    /*
    /// Helper method to login using two factor authentication
    public init(username: String, password: String, twoFactorCode: String) {
        self.username = username
        self.password = password
        self.twoFactorCode = twoFactorCode
        self.authMode = .twoFactor
    }
    */

}

extension MDAuthCredentials {

    /// Coding keys to encode our struct as JSON data
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }

}
