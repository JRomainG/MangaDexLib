//
//  MDAccountInfo.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure to store information when creating an account
public struct MDAccountInfo: Encodable {

    /// The username to use
    /// - Note: Must be between 1 and 64 characters
    public let username: String

    /// The password to use
    /// - Note: Must be between 8 and 1024 characters
    public let password: String

    /// The email address to use
    /// - Note: The address will be verified
    public let email: String

    public init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }

}
