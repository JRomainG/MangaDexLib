//
//  MDAuth.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Struct representing an auth action
struct MDAuth {

    /// Type of filtering when searching with tags
    enum AuthType: String {
        case regular
        case twoFactor
        case token
    }

    /// The username used to log in
    var username: String?

    /// The password used to log in
    var password: String?

    /// The saved token used to log in
    var token: String?

    /// Whether the auth uses two factor or not
    var type: AuthType

    /// Whether the user should be remembered (cookie is valid for 1 year)
    var remember: Bool

    /// Convenience method to init a username/password auth
    init(username: String, password: String, type: AuthType, remember: Bool) {
        self.username = username
        self.password = password
        self.type = type
        self.remember = remember
    }

    /// Convenience method to init a token auth
    init(token: String) {
        self.token = token
        self.type = .token
        self.remember = true
    }

}