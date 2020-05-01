//
//  MDAuth.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Struct representing an auth action
public struct MDAuth {

    /// Type of filtering when searching with tags
    public enum AuthType: String {
        /// Login using a username and password
        case regular

        /// Login using two factor authentication
        ///
        /// - Warning: Not yet supported
        case twoFactor

        /// Login using a previously used auth token
        case token
    }

    /// The username used to log in
    public var username: String?

    /// The password used to log in
    public var password: String?

    /// The saved token used to log in
    public var token: String?

    /// Whether the auth uses two factor or not
    public var type: AuthType

    /// Whether the user should be remembered (cookie is valid for 1 year)
    public var remember: Bool

    /// Convenience method to init a username/password auth
    public init(username: String, password: String, type: AuthType, remember: Bool) {
        self.username = username
        self.password = password
        self.type = type
        self.remember = remember
    }

    /// Convenience method to init a token auth
    public init(token: String) {
        self.token = token
        self.type = .token
        self.remember = true
    }

}
